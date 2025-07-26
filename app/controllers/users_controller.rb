class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users or /users.json
  def create
    # If this check is moved in `respond_to` next to this block, the error is not shown (idk why)
    if user_params[:password] != user_params[:password_confirmation]
      @user = User.new(email_address: user_params[:email_address])
      @errors = [ "パスワードと確認用パスワードが一致しません。" ]
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @errors, status: :unprocessable_entity }
      end
      return
    end
    respond_to do |format|
      begin
        @user = User.new(email_address: user_params[:email_address], password: user_params[:password])
        if @user.save
            clock_component = @user.layouts.create(
              direction: "vertical",
              child_type: "module",
              renew_period_minute: 1,
              contents: [
                { type: "spacer" },
                { type: "text", font_size: 56, text_align: "center", text: "12:34\n2025-01-01" },
                { type: "spacer" }
              ]
            )
            welcome_component = @user.layouts.create(
              direction: "vertical",
              child_type: "module",
              renew_period_minute: 0,
              contents: [
                { type: "spacer" },
                { type: "text", font_size: 32, text_align: "left", text: "Tultul へようこそ！" },
                { type: "text", font_size: 16, text_align: "left", text: "コンポーネントやレイアウトを編集してみましょう。" },
                { type: "spacer" }
              ]
            )
          root_layout = @user.layouts.create(direction: "horizontal", child_type: "layout", contents: [ clock_component.id, welcome_component.id ])
          @user.update(root_layout: root_layout.id)
          @errors = []
          format.html { redirect_to new_session_path, notice: "User was successfully created." }
          format.json { render :show, status: :created, location: @user }
        else
          @errors = @user.errors.map { |error| error.full_messages }
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @errors, status: :unprocessable_entity }
        end
      rescue
        puts "----------------------------------------"
        puts "[debug] Exception occurs while creating user"
        p $!
        puts "----------------------------------------"
        if @user and @user.errors.empty?
          @user.destroy
        end
        @errors = [ "ユーザーの作成中にエラーが発生しました。一定時間後に再試行してください。" ]
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
    end
end
