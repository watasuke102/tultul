class DatabasesController < ApplicationController
  before_action :set_database, except: [ :create ]
  # POST /databases or /databases.json
  def create
    create_params = database_params
    if create_params[:title] == nil
      create_params[:title] = "Database #{Current.user.databases.length + 1}"
    end
    @database = Current.user.databases.create(create_params)

    respond_to do |format|
      if @database.save
        format.html { redirect_to app_database_show_path(@database), notice: "Database was successfully created." }
        format.json { render :show, status: :created, location: @database }
      else
        format.html { redirect_to app_database_path, status: :unprocessable_entity }
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

  # POST /databases/:id/new_column
  def new_column
    new_column_name = "新規カラム"
    if @database.scheme[new_column_name].present?
      i = 1
      loop do
        new_column_name = "新規カラム (#{i})"
        break unless @database.scheme[new_column_name].present?
        i += 1
      end
    end
    @database.scheme[new_column_name] = "text"
    respond_to do |format|
      if @database.save
        format.html { redirect_to app_database_show_path(@database) }
        format.json { render :show, status: :row_created, location: @database }
      else
        format.html { redirect_to app_database_show_path(@database), status: :unprocessable_entity }
        format.json { render json: @database.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH /databases/:id/scheme/name
  def update_scheme_name
    head 422 unless params[:before].present? && !params[:after].present?
    @database.scheme.transform_keys!({ params[:before] => params[:after] })
    for e in @database.content
      e.transform_keys!({ params[:before] => params[:after] }) if e[params[:before]].present?
    end

    if @database.save
      head 200
    else
      head 422
    end
  end


  # POST /databases/:id/new_row
  def new_row
    @database.content.push({})
    respond_to do |format|
      if @database.save
        format.html { redirect_to app_database_show_path(@database) }
        format.json { render :show, status: :row_created, location: @database }
      else
        format.html { redirect_to app_database_show_path(@database), status: :unprocessable_entity }
        format.json { render json: @database.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH /databases/:id/:row
  def update_row
    @database.content[params[:row].to_i][params[:column]] = params[:value]
    if @database.save
      head 200
    else
      head 422
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
