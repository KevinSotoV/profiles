# for compatibility with Twitter Bootstrap

SimpleForm.form_class = :nice


SimpleForm::Inputs::StringInput.class_eval do
  alias :old_input_html_classes :input_html_classes
  def input_html_classes
    super + [:"input-text"]
  end
end

SimpleForm::Inputs::PasswordInput.class_eval do
  alias :old_input_html_classes :input_html_classes
  def input_html_classes
    super + [:"input-text"]
  end
end
