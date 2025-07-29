class DatabasesController < ApplicationController
  before_action :set_database, only: %i[ show edit update destroy ]
  # POST /databases or /databases.json
  def create
    @database = Current.user.databases.create(database_params)

    respond_to do |format|
      if @database.save
        format.html { redirect_to app_database_show_path(@database), notice: "Database was successfully created." }
        format.json { render :show, status: :created, location: @database }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @database.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /databases/1 or /databases/1.json
  def update
    puts "param => #{database_params.inspect}"
    respond_to do |format|
      if @database.update(database_params)
        format.html { redirect_to app_database_show_path(@database), notice: "Database was successfully updated." }
        format.json { render :show, status: :ok, location: @database }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @database.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /databases/1 or /databases/1.json
  def destroy
    @database.destroy!

    respond_to do |format|
      format.html { redirect_to database_path, status: :see_other, notice: "Database was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_database
      @database = Database.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def database_params
      params.fetch(:database, {}).permit(:title, :scheme, :content)
    end
end
