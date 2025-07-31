class LayoutController < ApplicationController
  def show
  end
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
