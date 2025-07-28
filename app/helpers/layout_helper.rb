module LayoutHelper
  def render_text(text)
    raise ArgumentError unless text.is_a?(String)
    text_array = text.split("")
    result = ""

    while text_array.any?
      c = text_array.shift
      if c != "{"
        result += c
        next
      end
      format_text = ""
      loop do
        c = text_array.shift
        if c.nil?
          result += "{" + format_text
          break
        end
        if c == "}"
          result += format(format_text)
          break
        end
        format_text += c
      end
    end

    result
  end

  def format(text)
    matched = text.match(/(\w+)\.(\w+)\.(\w+)/)
    if !matched
      text
    end

    case matched[1]
    when "builtin"
      render_builtin(matched[2], matched[3])
    else
      text
    end
  end
  def render_builtin(type, value)
    case type

    when "time"
      case value
      when "hour"
        Time.now.strftime("%H")
      when "min"
        Time.now.strftime("%M")
      when "year"
        Time.now.strftime("%Y")
      when "month"
        Time.now.strftime("%m")
      when "day"
        Time.now.strftime("%d")
      else
        raise ArgumentError, "Unknown builtin time value: #{value}"
      end

    else
      raise ArgumentError, "Unknown builtin type: #{type}"
    end
  end


  def module_style(mod)
    case mod["type"]
    when "text"
      [
        "display: inline-block",
        "width: 100%",
        "font-size: #{mod['font_size']}px",
        "text-align: #{mod['text_align']}"
      ].join("; ")
    else
      ""
    end
  end
end
