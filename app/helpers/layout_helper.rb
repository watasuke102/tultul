module LayoutHelper
  def module_style(mod)
    case mod["type"]
    when "text"
      "font-size: #{mod['font_size']}px; text-align: #{mod['text_align']};"
    else
      ""
    end
  end
end
