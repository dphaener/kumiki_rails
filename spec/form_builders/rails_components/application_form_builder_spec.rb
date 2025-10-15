require "rails_helper"

RSpec.describe RailsComponents::ApplicationFormBuilder, type: :helper do
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::TagHelper
  include RailsComponents::ComponentHelper

  # Mock model for testing
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :id, :integer
    attribute :name, :string
    attribute :email, :string
    attribute :password, :string
    attribute :age, :integer
    attribute :bio, :string
    attribute :active, :boolean
    attribute :gender, :string
    attribute :birth_date, :date
    attribute :work_time, :time
    attribute :appointment_datetime, :datetime
    attribute :avatar, :string

    validates :name, presence: true, length: { minimum: 2 }
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :age, numericality: { greater_than: 0 }

    def persisted?
      false
    end

    def to_key
      nil
    end

    def to_param
      nil
    end

    def model_name
      @model_name ||= ActiveModel::Name.new(self.class, nil, "TestModel")
    end
  end

  let(:model) { TestModel.new }
  let(:template) do
    view = helper
    view.extend(RailsComponents::ComponentHelper)
    view
  end
  let(:builder) { described_class.new(:test_model, model, template, {}) }

  # ============================================================================
  # INITIALIZATION TESTS
  # ============================================================================

  describe "initialization" do
    it "inherits from ActionView::Helpers::FormBuilder" do
      expect(builder).to be_kind_of(ActionView::Helpers::FormBuilder)
      expect(builder).to be_kind_of(RailsComponents::ApplicationFormBuilder)
    end

    it "has access to template and object" do
      expect(builder.instance_variable_get(:@template)).to eq(template)
      expect(builder.object).to eq(model)
      expect(builder.object_name).to eq(:test_model)
    end
  end

  # ============================================================================
  # TEXT FIELD TESTS
  # ============================================================================

  describe "#text_field" do
    context "with default options" do
      let(:html) { builder.text_field(:name) }

      it "renders a text input field" do
        expect(html).to include('input')
        expect(html).to include('type="text"')
        expect(html).to include('name="test_model[name]"')
        expect(html).to include('id="test_model_name"')
        expect(html).to include('class="input input-bordered')
      end

      it "generates automatic label" do
        expect(html).to include('<label')
        expect(html).to include('for="test_model_name"')
        expect(html).to include('<span class="label-text text-base">Name</span>')
      end
    end

    context "with custom label" do
      it "uses the custom label text" do
        html = builder.text_field(:name, label: "Full Name")
        expect(html).to include('<label')
        expect(html).to include('<span class="label-text text-base">Full Name</span>')
      end
    end

    context "with label disabled" do
      it "does not render a label" do
        html = builder.text_field(:name, label: false)
        expect(html).not_to include('<label')
        expect(html).not_to include('<span class="label-text text-base">Name</span>')
      end
    end

    context "with errors" do
      before do
        model.valid?
        model.errors.add(:name, "can't be blank")
        model.errors.add(:name, "is too short")
      end

      it "displays error messages" do
        html = builder.text_field(:name)
        expect(html).to include('input-error')
        expect(html).to include("can&#39;t be blank")
        expect(html).to include("is too short")
        expect(html).to include('class="text-error')
      end
    end

    context "without errors" do
      it "has no error styling" do
        html = builder.text_field(:name)
        expect(html).not_to include('input-error')
        expect(html).not_to include('text-error')
      end
    end

    context "with placeholder" do
      it "includes the placeholder attribute" do
        html = builder.text_field(:name, placeholder: "Enter your name")
        expect(html).to include('placeholder="Enter your name"')
      end
    end

    context "with required attribute" do
      it "includes required and aria-required attributes" do
        html = builder.text_field(:name, required: true)
        expect(html).to include('required="required"')
        expect(html).to include('aria-required="true"')
      end
    end

    context "with disabled attribute" do
      it "includes disabled attribute" do
        html = builder.text_field(:name, disabled: true)
        expect(html).to include('disabled="disabled"')
      end
    end

    context "with custom CSS classes" do
      it "merges custom classes with default classes" do
        html = builder.text_field(:name, class: "custom-class another-class")
        expect(html).to include('class="input input-bordered custom-class another-class')
      end
    end

    context "with data attributes" do
      it "includes data attributes" do
        html = builder.text_field(:name, data: { controller: "form", action: "input" })
        expect(html).to include('data-controller="form"')
        expect(html).to include('data-action="input"')
      end
    end

    context "with aria attributes" do
      it "includes aria attributes" do
        html = builder.text_field(:name, aria: { describedby: "name-help" })
        expect(html).to include('aria-describedby="name-help"')
      end
    end
  end

  # ============================================================================
  # EMAIL FIELD TESTS
  # ============================================================================

  describe "#email_field" do
    it "renders an email input field" do
      html = builder.email_field(:email)
      expect(html).to include('type="email"')
      expect(html).to include('name="test_model[email]"')
      expect(html).to include('id="test_model_email"')
      expect(html).to include('class="input input-bordered')
      expect(html).to include('<span class="label-text text-base">Email</span>')
    end

    context "with errors" do
      before do
        model.valid?
        model.errors.add(:email, "is invalid")
      end

      it "displays error messages" do
        html = builder.email_field(:email)
        expect(html).to include('input-error')
        expect(html).to include("is invalid")
      end
    end

    context "with autocomplete" do
      it "includes autocomplete attribute" do
        html = builder.email_field(:email, autocomplete: "email")
        expect(html).to include('autocomplete="email"')
      end
    end
  end

  # ============================================================================
  # PASSWORD FIELD TESTS
  # ============================================================================

  describe "#password_field" do
    it "renders a password input field" do
      html = builder.password_field(:password)
      expect(html).to include('type="password"')
      expect(html).to include('name="test_model[password]"')
      expect(html).to include('<span class="label-text text-base">Password</span>')
      expect(html).not_to include('value=')
    end

    context "with autocomplete" do
      it "includes autocomplete attribute" do
        html = builder.password_field(:password, autocomplete: "current-password")
        expect(html).to include('autocomplete="current-password"')
      end
    end
  end

  # ============================================================================
  # NUMBER FIELD TESTS
  # ============================================================================

  describe "#number_field" do
    it "renders a number input field" do
      html = builder.number_field(:age)
      expect(html).to include('type="number"')
      expect(html).to include('name="test_model[age]"')
      expect(html).to include('<span class="label-text text-base">Age</span>')
    end

    context "with min, max, and step" do
      it "includes min, max, and step attributes" do
        html = builder.number_field(:age, min: 18, max: 100, step: 1)
        expect(html).to include('min="18"')
        expect(html).to include('max="100"')
        expect(html).to include('step="1"')
      end
    end

    context "with errors" do
      before do
        model.valid?
        model.errors.add(:age, "must be greater than 0")
      end

      it "displays error messages" do
        html = builder.number_field(:age)
        expect(html).to include('input-error')
        expect(html).to include("must be greater than 0")
      end
    end
  end

  # ============================================================================
  # SELECT FIELD TESTS
  # ============================================================================

  describe "#select" do
    context "with options array" do
      let(:options) { [ [ "Male", "male" ], [ "Female", "female" ], [ "Other", "other" ] ] }

      it "renders a select field with options" do
        html = builder.select(:gender, options)
        expect(html).to include('<select')
        expect(html).to include('name="test_model[gender]"')
        expect(html).to include('class="select select-bordered')
        expect(html).to include('<span class="label-text text-base">Gender</span>')
        expect(html).to include('<option value="male">Male</option>')
        expect(html).to include('<option value="female">Female</option>')
        expect(html).to include('<option value="other">Other</option>')
      end
    end

    context "with options hash" do
      let(:options) { { "Male" => "male", "Female" => "female" } }

      it "renders options from hash" do
        html = builder.select(:gender, options)
        expect(html).to include('<option value="male">Male</option>')
        expect(html).to include('<option value="female">Female</option>')
      end
    end

    context "with prompt" do
      it "includes prompt attribute" do
        options = [ [ "Yes", true ], [ "No", false ] ]
        html = builder.select(:active, options, { prompt: "Please select" })
        expect(html).to include('prompt="Please select"')
      end
    end

    context "with selected value" do
      before { model.gender = "female" }

      it "marks the selected option" do
        options = [ [ "Male", "male" ], [ "Female", "female" ] ]
        html = builder.select(:gender, options)
        expect(html).to include('selected="selected">Female</option>')
      end
    end

    context "with errors" do
      before { model.errors.add(:gender, "is required") }

      it "displays error messages" do
        options = [ [ "Male", "male" ], [ "Female", "female" ] ]
        html = builder.select(:gender, options)
        expect(html).to include('select-error')
        expect(html).to include("is required")
      end
    end
  end

  # ============================================================================
  # TEXTAREA TESTS
  # ============================================================================

  describe "#textarea" do
    it "renders a textarea field" do
      html = builder.textarea(:bio)
      expect(html).to include('<textarea')
      expect(html).to include('name="test_model[bio]"')
      expect(html).to include('class="textarea textarea-bordered')
      expect(html).to include('<span class="label-text text-base">Bio</span>')
    end

    context "with rows and cols" do
      it "includes rows and cols attributes" do
        html = builder.textarea(:bio, rows: 5, cols: 40)
        expect(html).to include('rows="5"')
        expect(html).to include('cols="40"')
      end
    end

    context "with placeholder" do
      it "includes placeholder attribute" do
        html = builder.textarea(:bio, placeholder: "Tell us about yourself")
        expect(html).to include('placeholder="Tell us about yourself"')
      end
    end

    context "with errors" do
      before { model.errors.add(:bio, "is too short") }

      it "displays error messages" do
        html = builder.textarea(:bio)
        expect(html).to include('textarea-error')
        expect(html).to include("is too short")
      end
    end
  end

  # ============================================================================
  # CHECKBOX TESTS
  # ============================================================================

  describe "#check_box" do
    it "renders a checkbox field" do
      html = builder.check_box(:active)
      expect(html).to include('type="checkbox"')
      expect(html).to include('name="test_model[active]"')
      expect(html).to include('value="1"')
      expect(html).to include('class="checkbox')
      expect(html).to include('<span class="label-text">Active</span>')
    end

    context "with checked value" do
      before { model.active = true }

      it "renders the checkbox" do
        html = builder.check_box(:active)
        expect(html).to include('type="checkbox"')
      end
    end

    context "with custom values" do
      it "uses custom checked value" do
        html = builder.check_box(:active, {}, "yes", "no")
        expect(html).to include('value="yes"')
      end
    end

    context "with errors" do
      before { model.errors.add(:active, "must be accepted") }

      it "displays error messages" do
        html = builder.check_box(:active)
        expect(html).to include('checkbox-error')
        expect(html).to include("must be accepted")
      end
    end
  end

  # ============================================================================
  # RADIO BUTTON TESTS
  # ============================================================================

  describe "#radio_button" do
    it "renders a radio button" do
      html = builder.radio_button(:gender, "male")
      expect(html).to include('type="radio"')
      expect(html).to include('name="test_model[gender]"')
      expect(html).to include('value="male"')
      expect(html).to include('class="radio')
      expect(html).to include('<span class="label-text ml-2">Male</span>')
    end

    context "with checked value" do
      before { model.gender = "female" }

      it "marks the radio button as checked" do
        html = builder.radio_button(:gender, "female")
        expect(html).to include('checked="checked"')
      end
    end

    context "with custom label" do
      it "uses the custom label" do
        html = builder.radio_button(:gender, "male", label: "Male Option")
        expect(html).to include('<span class="label-text ml-2">Male Option</span>')
      end
    end

    context "with errors" do
      before { model.errors.add(:gender, "is required") }

      it "displays error messages" do
        html = builder.radio_button(:gender, "male")
        expect(html).to include('radio-error')
        expect(html).to include("is required")
      end
    end
  end

  # ============================================================================
  # DATE FIELD TESTS
  # ============================================================================

  describe "#date_field" do
    it "renders a date input field" do
      html = builder.date_field(:birth_date)
      expect(html).to include('type="date"')
      expect(html).to include('name="test_model[birth_date]"')
      expect(html).to include('<span class="label-text text-base">Birth date</span>')
    end

    context "with min and max" do
      it "includes min and max attributes" do
        html = builder.date_field(:birth_date, min: "1900-01-01", max: "2023-12-31")
        expect(html).to include('min="1900-01-01"')
        expect(html).to include('max="2023-12-31"')
      end
    end

    context "with errors" do
      before { model.errors.add(:birth_date, "is invalid") }

      it "displays error messages" do
        html = builder.date_field(:birth_date)
        expect(html).to include('input-error')
        expect(html).to include("is invalid")
      end
    end
  end

  # ============================================================================
  # TIME FIELD TESTS
  # ============================================================================

  describe "#time_field" do
    it "renders a time input field" do
      html = builder.time_field(:work_time)
      expect(html).to include('type="time"')
      expect(html).to include('name="test_model[work_time]"')
      expect(html).to include('<span class="label-text text-base">Work time</span>')
    end

    context "with step" do
      it "includes step attribute" do
        html = builder.time_field(:work_time, step: 60)
        expect(html).to include('step="60"')
      end
    end
  end

  # ============================================================================
  # DATETIME LOCAL FIELD TESTS
  # ============================================================================

  describe "#datetime_local_field" do
    it "renders a datetime-local input field" do
      html = builder.datetime_local_field(:appointment_datetime)
      expect(html).to include('type="datetime-local"')
      expect(html).to include('name="test_model[appointment_datetime]"')
      expect(html).to include('<span class="label-text text-base">Appointment datetime</span>')
    end

    context "with errors" do
      before { model.errors.add(:appointment_datetime, "can't be in the past") }

      it "displays error messages" do
        html = builder.datetime_local_field(:appointment_datetime)
        expect(html).to include('input-error')
        expect(html).to include("can&#39;t be in the past")
      end
    end
  end

  # ============================================================================
  # FILE FIELD TESTS
  # ============================================================================

  describe "#file_field" do
    it "renders a file input field" do
      html = builder.file_field(:avatar)
      expect(html).to include('type="file"')
      expect(html).to include('name="test_model[avatar]"')
      expect(html).to include('class="file-input file-input-bordered')
      expect(html).to include('<span class="label-text text-base">Avatar</span>')
    end

    context "with accept attribute" do
      it "includes accept attribute" do
        html = builder.file_field(:avatar, accept: "image/*")
        expect(html).to include('accept="image/*"')
      end
    end

    context "with multiple" do
      it "includes multiple attribute" do
        html = builder.file_field(:avatar, multiple: true)
        expect(html).to include('multiple="multiple"')
      end
    end

    context "with errors" do
      before { model.errors.add(:avatar, "is required") }

      it "displays error messages" do
        html = builder.file_field(:avatar)
        expect(html).to include('file-input-error')
        expect(html).to include("is required")
      end
    end
  end

  # ============================================================================
  # LABEL GENERATION TESTS
  # ============================================================================

  describe "label generation" do
    it "humanizes attribute names" do
      html = builder.text_field(:birth_date)
      expect(html).to include('<span class="label-text text-base">Birth date</span>')

      html = builder.text_field(:work_time)
      expect(html).to include('<span class="label-text text-base">Work time</span>')
    end

    context "with i18n" do
      around do |example|
        I18n.backend.store_translations(:en, {
          activemodel: {
            attributes: {
              test_model: {
                name: "Full Name"
              }
            }
          }
        })
        example.run
        I18n.backend.reload!
      end

      it "uses i18n translations" do
        html = builder.text_field(:name)
        expect(html).to include('<span class="label-text text-base">Full Name</span>')
      end
    end

    it "custom label text overrides automatic" do
      html = builder.text_field(:name, label: "Your Name")
      expect(html).to include('<span class="label-text text-base">Your Name</span>')
      expect(html).not_to include('<span class="label-text text-base">Name</span>')
    end

    it "label false disables label generation" do
      html = builder.text_field(:name, label: false)
      expect(html).not_to include('<label')
      expect(html).not_to include('</label>')
    end

    it "supports label with html options" do
      html = builder.text_field(:name, label: { text: "Name", class: "custom-label" })
      expect(html).to include('<span class="label-text text-base custom-label">Name</span>')
    end
  end

  # ============================================================================
  # ERROR RENDERING TESTS
  # ============================================================================

  describe "error rendering" do
    context "with single error message" do
      before { model.errors.add(:name, "can't be blank") }

      it "displays the error message" do
        html = builder.text_field(:name)
        expect(html).to include('class="text-error')
        expect(html).to include("can&#39;t be blank")
      end
    end

    context "with multiple error messages" do
      before do
        model.errors.add(:name, "can't be blank")
        model.errors.add(:name, "is too short")
        model.errors.add(:name, "contains invalid characters")
      end

      it "displays all error messages" do
        html = builder.text_field(:name)
        expect(html).to include("can&#39;t be blank")
        expect(html).to include("is too short")
        expect(html).to include("contains invalid characters")
      end
    end

    context "with no errors" do
      it "does not display error styling" do
        html = builder.text_field(:name)
        expect(html).not_to include('text-error')
        expect(html).not_to include('error')
      end
    end

    context "with error styling applied to input" do
      before { model.errors.add(:name, "is invalid") }

      it "applies error class to input" do
        html = builder.text_field(:name)
        expect(html).to include('input-error')
      end
    end

    context "for different field types" do
      before do
        model.errors.add(:bio, "is too short")
        model.errors.add(:gender, "is required")
        model.errors.add(:active, "must be accepted")
      end

      it "applies appropriate error classes" do
        textarea_html = builder.textarea(:bio)
        expect(textarea_html).to include('textarea-error')

        select_html = builder.select(:gender, [ [ "Male", "male" ] ])
        expect(select_html).to include('select-error')

        checkbox_html = builder.check_box(:active)
        expect(checkbox_html).to include('checkbox-error')
      end
    end
  end

  # ============================================================================
  # OPTION PASSING AND HTML ATTRIBUTE TESTS
  # ============================================================================

  describe "HTML attributes" do
    it "preserves custom HTML attributes" do
      html = builder.text_field(:name,
        id: "custom-id",
        class: "custom-class",
        data: { controller: "form" },
        aria: { label: "Full name input" }
      )

      expect(html).to include('id="custom-id"')
      expect(html).to include('class="input input-bordered custom-class')
      expect(html).to include('data-controller="form"')
      expect(html).to include('aria-label="Full name input"')
    end

    it "merges classes with DaisyUI classes" do
      html = builder.text_field(:name, class: "w-full max-w-xs")
      expect(html).to include('class="input input-bordered w-full max-w-xs')
    end

    it "supports standard HTML input attributes" do
      html = builder.text_field(:name,
        maxlength: 100,
        minlength: 2,
        pattern: "[A-Za-z]+",
        readonly: true,
        tabindex: 1
      )

      expect(html).to include('maxlength="100"')
      expect(html).to include('minlength="2"')
      expect(html).to include('pattern="[A-Za-z]+"')
      expect(html).to include('readonly="readonly"')
      expect(html).to include('tabindex="1"')
    end
  end

  # ============================================================================
  # DAISYUI INTEGRATION TESTS
  # ============================================================================

  describe "DaisyUI integration" do
    it "applies DaisyUI input classes" do
      html = builder.text_field(:name)
      expect(html).to include('class="input input-bordered')
    end

    it "applies DaisyUI select classes" do
      html = builder.select(:gender, [ [ "Male", "male" ] ])
      expect(html).to include('class="select select-bordered')
    end

    it "applies DaisyUI textarea classes" do
      html = builder.textarea(:bio)
      expect(html).to include('class="textarea textarea-bordered')
    end

    it "applies DaisyUI checkbox classes" do
      html = builder.check_box(:active)
      expect(html).to include('class="checkbox')
    end

    it "applies DaisyUI radio classes" do
      html = builder.radio_button(:gender, "male")
      expect(html).to include('class="radio')
    end

    it "applies DaisyUI file input classes" do
      html = builder.file_field(:avatar)
      expect(html).to include('class="file-input file-input-bordered')
    end

    context "with errors" do
      before { model.errors.add(:name, "is invalid") }

      it "applies DaisyUI error classes" do
        html = builder.text_field(:name)
        expect(html).to include('input-error')
      end
    end
  end

  # ============================================================================
  # ACCESSIBILITY TESTS
  # ============================================================================

  describe "accessibility" do
    context "with errors present" do
      before { model.errors.add(:name, "is invalid") }

      it "adds aria-invalid attribute" do
        html = builder.text_field(:name)
        expect(html).to include('aria-invalid="true"')
      end
    end

    context "with no errors" do
      it "does not add aria-invalid attribute" do
        html = builder.text_field(:name)
        expect(html).not_to include('aria-invalid="true"')
      end
    end

    it "label for attribute matches input id" do
      html = builder.text_field(:name)
      expect(html).to include('for="test_model_name"')
      expect(html).to include('id="test_model_name"')
    end

    context "with required attribute" do
      it "adds aria-required attribute" do
        html = builder.text_field(:name, required: true)
        expect(html).to include('aria-required="true"')
      end
    end

    describe "radio button groups" do
      it "uses the same name for radio buttons in a group" do
        html1 = builder.radio_button(:gender, "male")
        html2 = builder.radio_button(:gender, "female")

        expect(html1).to include('name="test_model[gender]"')
        expect(html2).to include('name="test_model[gender]"')
      end
    end
  end

  # ============================================================================
  # EDGE CASES AND ERROR HANDLING TESTS
  # ============================================================================

  describe "edge cases" do
    context "with nil value attribute" do
      before { model.name = nil }

      it "renders the input without value attribute" do
        html = builder.text_field(:name)
        expect(html).to include('<input')
      end
    end

    context "with empty string value" do
      before { model.name = "" }

      it "renders empty value attribute" do
        html = builder.text_field(:name)
        expect(html).to include('value=""')
      end
    end

    context "with special characters in value" do
      before { model.name = "John & Jane's \"Special\" <Name>" }

      it "properly escapes special characters" do
        html = builder.text_field(:name)
        expect(html).to include('value="John &amp; Jane&#39;s &quot;Special&quot; &lt;Name&gt;"')
      end
    end

    context "with non-existent attribute" do
      it "handles gracefully" do
        html = builder.text_field(:non_existent_field)
        expect(html).to include('name="test_model[non_existent_field]"')
        expect(html).to include('<span class="label-text text-base">Non existent field</span>')
      end
    end

    context "with nil object" do
      let(:builder_with_nil) { described_class.new(:test_model, nil, template, {}) }

      it "handles nil object gracefully" do
        html = builder_with_nil.text_field(:name)
        expect(html).to include('name="test_model[name]"')
        expect(html).to include('<span class="label-text text-base">Name</span>')
      end
    end

    it "wraps field in form control container" do
      html = builder.text_field(:name)
      expect(html).to include('class="form-control')
    end

    it "positions label before input" do
      html = builder.text_field(:name)
      label_position = html.index('<label')
      input_position = html.index('<input')
      expect(label_position).to be < input_position
    end

    context "with errors" do
      before { model.errors.add(:name, "is invalid") }

      it "positions error messages after input" do
        html = builder.text_field(:name)
        input_position = html.index('<input')
        error_position = html.index('is invalid')
        expect(input_position).to be < error_position
      end
    end
  end

  # ============================================================================
  # FORM BUILDER INTEGRATION TESTS
  # ============================================================================

  describe "integration with form_with helper" do
    it "works with form_with helper" do
      output = helper.form_with(model: model, url: "/test_models", builder: RailsComponents::ApplicationFormBuilder, local: true) do |form|
        form.text_field(:name)
      end

      expect(output).to include('class="input input-bordered')
      expect(output).to include('<span class="label-text text-base">Name</span>')
    end

    it "supports nested attributes" do
      html = builder.fields_for(:address) do |address_form|
        address_form.text_field(:street)
      end

      expect(html).to include('name="test_model[address][street]"')
    end
  end

  # ============================================================================
  # PERFORMANCE AND OPTIMIZATION TESTS
  # ============================================================================

  describe "performance" do
    context "with repeated error lookups" do
      before { model.errors.add(:name, "is invalid") }

      it "produces consistent output" do
        html1 = builder.text_field(:name)
        html2 = builder.text_field(:name)
        expect(html1).to eq(html2)
      end
    end

    context "with large error sets" do
      before do
        100.times { |i| model.errors.add(:name, "Error #{i}") }
      end

      it "handles large error sets" do
        html = builder.text_field(:name)
        expect(html).to include('Error 0')
        expect(html).to include('Error 99')
      end
    end
  end

  # ============================================================================
  # VALIDATION INTEGRATION TESTS
  # ============================================================================

  describe "validation integration" do
    context "with validation errors from model" do
      before do
        model.name = ""
        model.email = "invalid-email"
        model.age = -5
        model.valid?
      end

      it "displays validation errors properly" do
        name_html = builder.text_field(:name)
        email_html = builder.email_field(:email)
        age_html = builder.number_field(:age)

        expect(name_html).to include("can&#39;t be blank")
        expect(name_html).to include("is too short")
        expect(email_html).to include("is invalid")
        expect(age_html).to include("must be greater than 0")
      end
    end

    context "with valid data" do
      before do
        model.name = "Valid Name"
        model.email = "valid@example.com"
        model.valid?
      end

      it "does not show error styling" do
        name_html = builder.text_field(:name)
        email_html = builder.email_field(:email)

        expect(name_html).not_to include('input-error')
        expect(email_html).not_to include('input-error')
        expect(name_html).not_to include('aria-invalid')
        expect(email_html).not_to include('aria-invalid')
      end
    end
  end

  # ============================================================================
  # INTERNATIONALIZATION (I18N) TESTS
  # ============================================================================

  describe "internationalization" do
    around do |example|
      I18n.backend.store_translations(:en, {
        activemodel: {
          attributes: {
            test_model: {
              email: "Email Address",
              bio: "Biography"
            }
          }
        }
      })
      example.run
      I18n.backend.reload!
    end

    it "uses i18n model attributes" do
      email_html = builder.email_field(:email)
      bio_html = builder.textarea(:bio)

      expect(email_html).to include('<span class="label-text text-base">Email Address</span>')
      expect(bio_html).to include('<span class="label-text text-base">Biography</span>')
    end
  end

  describe "i18n helpers fallback" do
    around do |example|
      I18n.backend.store_translations(:en, {
        helpers: {
          label: {
            test_model: {
              name: "Full Name (from helpers)"
            }
          }
        }
      })
      example.run
      I18n.backend.reload!
    end

    it "uses i18n helpers translations" do
      html = builder.text_field(:name)
      expect(html).to include('<span class="label-text text-base">Full Name (from helpers)</span>')
    end
  end

  describe "error message i18n" do
    around do |example|
      I18n.backend.store_translations(:en, {
        activemodel: {
          errors: {
            models: {
              test_model: {
                attributes: {
                  name: {
                    blank: "Name is required in our system"
                  }
                }
              }
            }
          }
        }
      })
      example.run
      I18n.backend.reload!
    end

    it "supports i18n error messages" do
      model.errors.add(:name, :blank)
      html = builder.text_field(:name)
      expect(html).to include("Name is required in our system")
    end
  end

  # ============================================================================
  # COMPLEX FORM SCENARIOS TESTS
  # ============================================================================

  describe "complex form scenarios" do
    context "with polymorphic associations" do
      let(:builder_with_prefix) { described_class.new("user[profile]", model, template, {}) }

      it "handles polymorphic association names" do
        html = builder_with_prefix.text_field(:name)
        expect(html).to include('name="user[profile][name]"')
        expect(html).to include('id="user_profile_name"')
      end
    end

    context "with array parameters" do
      let(:builder_with_array) { described_class.new("user[]", model, template, {}) }

      it "handles array parameters" do
        html = builder_with_array.text_field(:name)
        expect(html).to include('name="user[][name]"')
      end
    end

    context "with deep nested attributes" do
      let(:nested_builder) { described_class.new("user[addresses_attributes][0]", model, template, {}) }

      it "handles deeply nested attributes" do
        html = nested_builder.text_field(:street)
        expect(html).to include('name="user[addresses_attributes][0][street]"')
        expect(html).to include('id="user_addresses_attributes_0_street"')
      end
    end
  end

  # ============================================================================
  # SECURITY TESTS
  # ============================================================================

  describe "security" do
    it "escapes dangerous content in labels" do
      html = builder.text_field(:name, label: "<script>alert('xss')</script>Name")
      expect(html).not_to include('<script>')
      expect(html).to include('&lt;script&gt;')
    end

    context "with dangerous content in values" do
      before { model.name = "<script>alert('xss')</script>" }

      it "escapes dangerous content" do
        html = builder.text_field(:name)
        expect(html).not_to include('<script>')
        expect(html).to include('&lt;script&gt;')
      end
    end

    context "with dangerous content in errors" do
      before { model.errors.add(:name, "<script>alert('xss')</script>") }

      it "escapes dangerous content" do
        html = builder.text_field(:name)
        expect(html).not_to include('<script>')
        expect(html).to include('&lt;script&gt;')
      end
    end
  end

  # ============================================================================
  # RESPONSIVE DESIGN TESTS
  # ============================================================================

  describe "responsive design" do
    it "supports responsive classes" do
      html = builder.text_field(:name, class: "w-full sm:w-1/2 lg:w-1/3")
      expect(html).to include('w-full sm:w-1/2 lg:w-1/3')
      expect(html).to include('input input-bordered')
    end

    context "with size variants" do
      it "supports size variants" do
        small_html = builder.text_field(:name, size: "sm")
        large_html = builder.text_field(:name, size: "lg")

        expect(small_html).to include('input-sm')
        expect(large_html).to include('input-lg')
      end
    end
  end

  # ============================================================================
  # FORM STATE MANAGEMENT TESTS
  # ============================================================================

  describe "form state management" do
    context "with readonly fields" do
      it "includes readonly attribute" do
        html = builder.text_field(:name, readonly: true)
        expect(html).to include('readonly="readonly"')
        expect(html).to include('input-bordered')
      end
    end

    context "with hidden fields" do
      it "renders hidden field without label" do
        html = builder.hidden_field(:id)
        expect(html).to include('type="hidden"')
        expect(html).to include('name="test_model[id]"')
        expect(html).not_to include('<label')
      end
    end

    context "with existing values" do
      before do
        model.name = "Existing Name"
        model.email = "existing@example.com"
        model.age = 25
      end

      it "preserves existing values" do
        name_html = builder.text_field(:name)
        email_html = builder.email_field(:email)
        age_html = builder.number_field(:age)

        expect(name_html).to include('value="Existing Name"')
        expect(email_html).to include('value="existing@example.com"')
        expect(age_html).to include('value="25"')
      end
    end
  end

  # ============================================================================
  # BROWSER COMPATIBILITY TESTS
  # ============================================================================

  describe "browser compatibility" do
    it "generates valid HTML5" do
      html = builder.email_field(:email, required: true)
      expect(html).to include('type="email"')
      expect(html).to include('required="required"')
    end

    it "supports autocomplete attributes" do
      html = builder.text_field(:name, autocomplete: "given-name")
      expect(html).to include('autocomplete="given-name"')
    end

    it "supports inputmode attribute" do
      html = builder.text_field(:phone, inputmode: "tel")
      expect(html).to include('inputmode="tel"')
    end
  end

  # ============================================================================
  # COMPREHENSIVE INTEGRATION TESTS
  # ============================================================================

  describe "complete form integration scenario" do
    before do
      model.name = "John Doe"
      model.email = "john@example.com"
      model.active = true
      model.gender = "male"
      model.errors.add(:age, "is required")
    end

    it "renders all field types correctly" do
      name_html = builder.text_field(:name, required: true)
      email_html = builder.email_field(:email, autocomplete: "email")
      password_html = builder.password_field(:password, required: true)
      age_html = builder.number_field(:age, min: 18, max: 100)
      gender_html = builder.select(:gender, [ [ "Male", "male" ], [ "Female", "female" ] ], { prompt: "Select gender" })
      bio_html = builder.textarea(:bio, rows: 4, placeholder: "Tell us about yourself")
      active_html = builder.check_box(:active)

      # Verify all fields render correctly
      expect(name_html).to include('value="John Doe"')
      expect(name_html).to include('required="required"')
      expect(email_html).to include('value="john@example.com"')
      expect(email_html).to include('autocomplete="email"')
      expect(password_html).to include('type="password"')
      expect(age_html).to include('input-error')
      expect(age_html).to include('is required')
      expect(gender_html).to include('selected="selected">Male')
      expect(bio_html).to include('placeholder="Tell us about yourself"')
      expect(active_html).to include('type="checkbox"')

      # Verify proper DaisyUI classes
      expect(name_html).to include('input input-bordered')
      expect(email_html).to include('input input-bordered')
      expect(password_html).to include('input input-bordered')
      expect(age_html).to include('input input-bordered input-error')
      expect(gender_html).to include('select select-bordered')
      expect(bio_html).to include('textarea textarea-bordered')
      expect(active_html).to include('checkbox')
    end
  end
end
