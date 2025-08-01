class LayoutController < ApplicationController
  def update
    layout = Current.user.layouts.find(params[:id])
    layout.contents[params[:content_index].to_i].merge!(params[:module].permit!.to_h)

    if layout.save
      redirect_to app_dashboard_edit_path, status: :ok
    else
      redirect_to app_dashboard_edit_path, status: :unprocessable_entity
    end
  end

  # POST /layout/:id/switch_direction
  def switch_direction
    layout = Current.user.layouts.find(params[:id])
    layout.direction = layout.direction == "horizontal" ? "vertical" : "horizontal"
    layout.save
    redirect_to app_dashboard_edit_path
  end

  # POST /layouts/:id
  def create_child
    parent = Current.user.layouts.find(params[:id])
    case parent.child_type
    when "layout"
      child = Current.user.layouts.create(params.permit(:child_type, :direction))
      if !child.save
        redirect_to app_dashboard_edit_path, status: :unprocessable_entity
        return
      end
      parent.contents << child.id

    when "module"
      parent.contents << { "type" => "spacer" }
    end

    redirect_to app_dashboard_edit_path, status: parent.save ? :ok : :unprocessable_entity
  end

  # DELETE /layouts/:id
  def delete
    layout = Current.user.layouts.find(params.expect(:id))
    if layout == Current.user.root_layout
      redirect_to app_dashboard_path, status: :unprocessable_entity
      return
    end
    remove_layout(target: layout, from: Current.user.root_layout)
    layout.destroy
    redirect_to app_dashboard_path
  end
  # DELETE /layouts/:id/:module_index
  def delete_module
    layout = Current.user.layouts.find(params[:id])
    if layout.child_type != "module"
      redirect_to app_dashboard_edit_path, status: :unprocessable_entity
    end

    layout.contents.delete_at(params[:module_index].to_i)
    layout.save
    redirect_to app_dashboard_edit_path, status: :ok
  end

  private
    def remove_layout(target:, from:)
      if from.child_type != "layout"
        return
      end
      if from.contents.delete(target) != nil
        return
      end
      from.contents.each do |child_id|
        child_layout = Layout.find(child_id)
        remove_layout(target: target, from: child_layout)
        child_layout.save
      end
      from.save
    end
end
