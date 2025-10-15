require "rails_helper"
require "benchmark"

RSpec.describe Kumiki::ApplicationFormBuilder, type: :helper do
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::TagHelper
  include Kumiki::ComponentHelper

  # Performance test model
  class PerformanceModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :name, :string
    attribute :email, :string
    attribute :description, :string

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
      @model_name ||= ActiveModel::Name.new(self.class, nil, "PerformanceModel")
    end
  end

  let(:model) { PerformanceModel.new }
  let(:template) do
    view = helper
    view.extend(Kumiki::ComponentHelper)
    view
  end
  let(:builder) { described_class.new(:performance_model, model, template, {}) }

  # ============================================================================
  # BASIC PERFORMANCE BENCHMARKS
  # ============================================================================

  describe "basic performance" do
    it "renders single fields efficiently" do
      time = Benchmark.measure do
        1000.times do
          builder.text_field(:name)
        end
      end

      expect(time.real).to be < 1.0
    end

    context "with errors" do
      before do
        model.errors.add(:name, "is invalid")
        model.errors.add(:name, "is too short")
        model.errors.add(:name, "contains invalid characters")
      end

      it "renders fields with errors efficiently" do
        time = Benchmark.measure do
          500.times do
            builder.text_field(:name)
          end
        end

        expect(time.real).to be < 1.0
      end
    end

    it "renders multiple field types efficiently" do
      time = Benchmark.measure do
        100.times do
          builder.text_field(:name)
          builder.email_field(:email)
          builder.textarea(:description)
          builder.select(:status, [ [ "Active", "active" ], [ "Inactive", "inactive" ] ])
          builder.check_box(:confirmed)
          builder.radio_button(:gender, "male")
          builder.number_field(:age)
          builder.date_field(:birth_date)
          builder.password_field(:password)
          builder.file_field(:avatar)
        end
      end

      expect(time.real).to be < 2.0
    end
  end

  # ============================================================================
  # MEMORY USAGE TESTS
  # ============================================================================

  describe "memory usage" do
    it "uses memory efficiently with large forms" do
      initial_memory = memory_usage

      100.times do |i|
        builder.text_field("field_#{i}".to_sym,
          placeholder: "Enter field #{i}",
          class: "custom-class-#{i}",
          data: { index: i, controller: "form" }
        )
      end

      final_memory = memory_usage
      memory_increase = final_memory - initial_memory

      expect(memory_increase).to be < 50_000_000
    end

    it "does not leak memory with repeated rendering" do
      initial_memory = memory_usage

      1000.times do
        builder.text_field(:name, class: "form-control", placeholder: "Enter name")
      end

      GC.start
      GC.compact if GC.respond_to?(:compact)

      final_memory = memory_usage
      memory_increase = final_memory - initial_memory

      expect(memory_increase).to be < 10_000_000
    end
  end

  # ============================================================================
  # SCALABILITY TESTS
  # ============================================================================

  describe "scalability" do
    context "with many errors" do
      before do
        100.times do |i|
          model.errors.add(:name, "Error message #{i}")
        end
      end

      it "handles many errors efficiently" do
        time = Benchmark.measure do
          50.times do
            builder.text_field(:name)
          end
        end

        expect(time.real).to be < 1.0
      end
    end

    context "with complex HTML options" do
      let(:complex_options) do
        {
          class: [ "form-control", "input-lg", "custom-field", "validated" ],
          data: {
            controller: "form-validation",
            action: "input->form-validation#validate focus->form-validation#highlight",
            target: "form-validation.field",
            rules: "required|min:2|max:50",
            error_container: "#name-errors"
          },
          aria: {
            label: "Full name input field",
            describedby: "name-help name-errors",
            required: true,
            invalid: false
          },
          autocomplete: "given-name",
          placeholder: "Enter your full name",
          maxlength: 100,
          pattern: "[A-Za-z ]+",
          required: true,
          tabindex: 1
        }
      end

      it "handles complex options efficiently" do
        time = Benchmark.measure do
          100.times do
            builder.text_field(:name, complex_options)
          end
        end

        expect(time.real).to be < 1.0
      end
    end

    context "with i18n lookups" do
      around do |example|
        I18n.backend.store_translations(:en, {
          activemodel: {
            attributes: {
              performance_model: {
                name: "Full Name",
                email: "Email Address",
                description: "Description"
              }
            }
          },
          helpers: {
            label: {
              performance_model: {
                name: "Your Full Name",
                email: "Your Email Address"
              }
            }
          }
        })
        example.run
        I18n.backend.reload!
      end

      it "handles i18n lookups efficiently" do
        time = Benchmark.measure do
          200.times do
            builder.text_field(:name)
            builder.email_field(:email)
            builder.textarea(:description)
          end
        end

        expect(time.real).to be < 1.0
      end
    end
  end

  # ============================================================================
  # CONCURRENT PERFORMANCE TESTS
  # ============================================================================

  describe "concurrent performance" do
    it "performs well under concurrent access" do
      threads = []
      start_time = Time.now

      10.times do |i|
        threads << Thread.new do
          local_model = PerformanceModel.new
          local_model.name = "Thread #{i}"
          local_builder = described_class.new("thread_#{i}".to_sym, local_model, template, {})

          100.times do
            local_builder.text_field(:name)
            local_builder.email_field(:email)
          end
        end
      end

      threads.each(&:join)
      total_time = Time.now - start_time

      expect(total_time).to be < 3.0
    end
  end

  # ============================================================================
  # REAL-WORLD SCENARIO TESTS
  # ============================================================================

  describe "real-world scenarios" do
    context "typical user registration form" do
      before do
        model.errors.add(:email, "has already been taken")
        model.errors.add(:password, "is too short")
      end

      it "renders efficiently" do
        time = Benchmark.measure do
          100.times do
            builder.text_field(:first_name, required: true, autocomplete: "given-name")
            builder.text_field(:last_name, required: true, autocomplete: "family-name")
            builder.email_field(:email, required: true, autocomplete: "email")
            builder.password_field(:password, required: true, autocomplete: "new-password")
            builder.password_field(:password_confirmation, required: true, autocomplete: "new-password")
            builder.select(:country, [ [ "United States", "US" ], [ "Canada", "CA" ] ], { prompt: "Select country" })
            builder.date_field(:birth_date)
            builder.check_box(:terms_accepted, required: true)
            builder.check_box(:marketing_emails)
            builder.textarea(:bio, rows: 3, placeholder: "Tell us about yourself")
          end
        end

        expect(time.real).to be < 2.0
      end
    end

    context "complex admin form" do
      before do
        20.times do |i|
          model.errors.add("field_#{i}".to_sym, "has an error")
        end
      end

      it "renders efficiently" do
        time = Benchmark.measure do
          10.times do
            30.times do |i|
              builder.text_field("text_field_#{i}".to_sym,
                class: "form-control",
                data: { controller: "validation", target: "form.field" }
              )
            end

            10.times do |i|
              builder.select("select_field_#{i}".to_sym,
                (1..50).map { |j| [ "Option #{j}", j ] },
                { prompt: "Choose option" }
              )
            end

            5.times do |i|
              builder.textarea("textarea_field_#{i}".to_sym, rows: 4)
            end
          end
        end

        expect(time.real).to be < 3.0
      end
    end
  end

  # ============================================================================
  # OPTIMIZATION VERIFICATION TESTS
  # ============================================================================

  describe "optimization verification" do
    context "with HTML escaping" do
      before do
        model.name = "<script>alert('xss')</script>" * 100
        model.errors.add(:name, "<script>alert('error')</script>" * 50)
      end

      it "escapes HTML efficiently" do
        time = Benchmark.measure do
          100.times do
            builder.text_field(:name, label: "<script>alert('label')</script>")
          end
        end

        expect(time.real).to be < 1.0
      end
    end
  end

  private

  def memory_usage
    return 0 unless File.readable?("/proc/self/status")

    File.read("/proc/self/status").scan(/VmRSS:\s+(\d+)/).flatten.first.to_i * 1024
  rescue
    0
  end
end
