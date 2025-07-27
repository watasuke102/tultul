require "test_helper"

class LayoutTest < ActiveSupport::TestCase
  setup do
    begin
      @u = User.find_by(email_address: "layouttest@example.com")
    rescue
      @u = User.create!(
        email_address: "layouttest@example.com",
        password: "a",
        password_confirmation: "a"
      )
    end
  end

  test "Layout whose child type is Layout can be created without errors" do
    l = @u.layouts.create(
      direction: "horizontal",
      child_type: "layout",
      contents: []
    )
    assert l.valid?, l.errors.full_messages.inspect
  end

  test "Layout creation raises error when direction is neither `horizontal` nor `vertical`" do
    l = @u.layouts.create(
      direction: "foobar",
      child_type: "layout",
      contents: []
    )
    assert_not l.valid?
  end
  test "Layout creation raises error when child_type is neither `layout` nor `module`" do
    l = @u.layouts.create(
      direction: "horizontal",
      child_type: "foobar",
      contents: []
    )
    assert_not l.valid?
  end

  test "Layout creation raises error when its child type is Layout but content is Module" do
    l = @u.layouts.create(
      direction: "horizontal",
      child_type: "layout",
      contents: [
        { type: "text", text: "invalid" }
      ]
    )
    assert_not l.valid?
  end
  test "Layout creation raises error when its child type is Module but content is Layout" do
    l = @u.layouts.create(
      direction: "horizontal",
      child_type: "module",
      contents: [
        ""
      ]
    )
    assert_not l.valid?
  end

  test "module creation raises error if the type is undefined" do
    l = @u.layouts.create(
      direction: "vertical",
      child_type: "module",
      contents: [
        { type: "foobar" }
      ]
    )
    assert_not l.valid?
  end

  # modules:text
  test "Text modules can be created without errors" do
    l = @u.layouts.create(
      direction: "vertical",
      child_type: "module",
      contents: [
        { type: "text", text: "Hello, world!" }
      ]
    )
    assert l.valid?, l.errors.full_messages.inspect
    assert_equal l.contents.first["font_size"], 16
    assert_equal l.contents.first["text_align"], "left"
  end
end
