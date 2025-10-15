require "rails_helper"

RSpec.describe RailsComponents::ApplicationFormBuilder, type: :helper do
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::TagHelper
  include RailsComponents::ComponentHelper

  # Simplified test model for edge cases
  class EdgeCaseModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :name, :string
    attribute :count, :integer

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
      @model_name ||= ActiveModel::Name.new(self.class, nil, "EdgeCaseModel")
    end
  end

  let(:model) { EdgeCaseModel.new }
  let(:template) do
    view = helper
    view.extend(RailsComponents::ComponentHelper)
    view
  end
  let(:builder) { described_class.new(:edge_case_model, model, template, {}) }

  # ============================================================================
  # UNICODE AND ENCODING TESTS
  # ============================================================================

  describe "unicode and encoding" do
    context "with unicode content" do
      before { model.name = "François José 中文 العربية 🚀" }

      it "handles unicode content" do
        html = builder.text_field(:name)
        expect(html).to include('François José 中文 العربية 🚀')
        expect(html.encoding.name).to eq("UTF-8")
        expect(html.valid_encoding?).to be true
      end
    end

    context "with unicode labels" do
      it "handles unicode in labels" do
        html = builder.text_field(:name, label: "Nom d'utilisateur (français)")
        expect(html).to match(/Nom d(?:&#39;|')utilisateur \(français\)/)
        expect(html.encoding.name).to eq("UTF-8")
        expect(html.valid_encoding?).to be true
      end
    end

    context "with unicode error messages" do
      before { model.errors.add(:name, "Le nom ne peut pas être vide") }

      it "handles unicode in error messages" do
        html = builder.text_field(:name)
        expect(html).to include("Le nom ne peut pas être vide")
        expect(html.encoding.name).to eq("UTF-8")
        expect(html.valid_encoding?).to be true
      end
    end
  end

  # ============================================================================
  # HTML ENTITY ENCODING TESTS
  # ============================================================================

  describe "HTML entity encoding" do
    context "with ampersands" do
      before { model.name = "Johnson & Johnson" }

      it "properly encodes ampersands" do
        html = builder.text_field(:name)
        expect(html).to include("Johnson &amp; Johnson")
        expect(html).not_to include("Johnson & Johnson")
      end
    end

    context "with quotes in attributes" do
      it "properly encodes quotes" do
        html = builder.text_field(:name, placeholder: 'Enter "your" name')
        expect(html).to include('placeholder="Enter &quot;your&quot; name"')
      end
    end

    context "with less than and greater than signs" do
      before { model.name = "<script>alert('test')</script>" }

      it "properly encodes angle brackets" do
        html = builder.text_field(:name)
        expect(html).to include("&lt;script&gt;")
        expect(html).not_to include("<script>")
      end
    end
  end

  # ============================================================================
  # MEMORY AND PERFORMANCE EDGE CASES
  # ============================================================================

  describe "memory and performance edge cases" do
    context "with very long field names" do
      it "handles very long field names" do
        long_name = "a" * 1000
        html = builder.text_field(long_name.to_sym)
        expect(html).to include("name=\"edge_case_model[#{long_name}]\"")
      end
    end

    context "with very long values" do
      it "handles very long values" do
        long_value = "b" * 10000
        model.name = long_value
        html = builder.text_field(:name)
        expect(html).to include(long_value)
      end
    end

    context "with many CSS classes" do
      it "handles many CSS classes" do
        classes = (1..100).map { |i| "class-#{i}" }.join(" ")
        html = builder.text_field(:name, class: classes)
        expect(html).to include(classes)
        expect(html).to include("input input-bordered")
      end
    end
  end

  # ============================================================================
  # CONCURRENT ACCESS TESTS
  # ============================================================================

  describe "concurrent access" do
    it "handles thread safety with shared model", skip: ENV["CI"] do
      mutex = Mutex.new
      results = {}

      threads = (0..4).map do |i|
        Thread.new do
          thread_index = i
          local_model = EdgeCaseModel.new
          local_model.name = "Thread #{thread_index}"

          local_template = template.dup
          local_builder = described_class.new(:thread_model, local_model, local_template, {})

          html = local_builder.text_field(:name)

          mutex.synchronize do
            results[thread_index] = html
          end
        end
      end

      threads.each(&:join)

      expect(results.length).to eq(5)

      (0..4).each do |i|
        expect(results).to have_key(i)
        expect(results[i]).to include("value=\"Thread #{i}\"")
      end
    end
  end

  # ============================================================================
  # ERROR BOUNDARY TESTS
  # ============================================================================

  describe "error boundaries" do
    context "with nil object" do
      let(:builder_with_nil) { described_class.new(:nil_model, nil, template, {}) }

      it "handles nil object gracefully" do
        expect do
          html = builder_with_nil.text_field(:name)
          expect(html).to include('name="nil_model[name]"')
        end.not_to raise_error
      end
    end

    context "with missing method on object" do
      it "handles missing methods gracefully" do
        html = builder.text_field(:non_existent_field)
        expect(html).to include('name="edge_case_model[non_existent_field]"')
        expect(html).to match(/<span class="label-text text-base">Non existent field<\/span>/)
      end
    end

    context "with nil errors object" do
      before do
        allow(model).to receive(:errors).and_return(nil)
      end

      it "handles nil errors object" do
        expect do
          html = builder.text_field(:name)
          expect(html).not_to include('input-error')
        end.not_to raise_error
      end
    end
  end

  # ============================================================================
  # EXTREME VALUE TESTS
  # ============================================================================

  describe "extreme values" do
    context "with zero values" do
      before { model.count = 0 }

      it "handles zero values" do
        html = builder.number_field(:count)
        expect(html).to include('value="0"')
      end
    end

    context "with negative values" do
      before { model.count = -999 }

      it "handles negative values" do
        html = builder.number_field(:count)
        expect(html).to include('value="-999"')
      end
    end

    context "with very large numbers" do
      before { model.count = 999999999999999 }

      it "handles very large numbers" do
        html = builder.number_field(:count)
        expect(html).to include('value="999999999999999"')
      end
    end

    context "with empty string values" do
      before { model.name = "" }

      it "handles empty string values" do
        html = builder.text_field(:name)
        expect(html).to include('value=""')
      end
    end

    context "with whitespace only values" do
      before { model.name = "   \t\n   " }

      it "handles whitespace only values" do
        html = builder.text_field(:name)
        expect(html).to include("   \t\n   ")
      end
    end
  end

  # ============================================================================
  # MALFORMED INPUT TESTS
  # ============================================================================

  describe "malformed input" do
    context "with invalid HTML attributes" do
      it "escapes dangerous content in attributes" do
        html = builder.text_field(:name,
          class: '"malicious" onclick="alert(1)"',
          id: 'test"id',
          data: { value: '"test"' }
        )

        expect(html).not_to include('onclick="alert(1)"')
        expect(html).to include('&quot;malicious&quot;')
      end
    end

    context "with circular reference in options" do
      it "handles circular references gracefully" do
        options = {}
        options[:self] = options

        expect do
          html = builder.text_field(:name, data: { test: "simple" })
          expect(html).to include('data-test="simple"')
        end.not_to raise_error
      end
    end
  end

  # ============================================================================
  # BROWSER QUIRKS TESTS
  # ============================================================================

  describe "browser quirks" do
    it "handles IE-specific attributes" do
      html = builder.text_field(:name, autocomplete: "off")
      expect(html).to include('autocomplete="off"')
    end

    it "handles Safari-specific attributes" do
      html = builder.date_field(:created_at, min: "2020-01-01")
      expect(html).to include('min="2020-01-01"')
    end
  end

  # ============================================================================
  # I18N EDGE CASES
  # ============================================================================

  describe "i18n edge cases" do
    context "with missing i18n keys" do
      around do |example|
        I18n.backend.store_translations(:en, {})
        example.run
        I18n.backend.reload!
      end

      it "falls back to humanized attribute name" do
        html = builder.text_field(:name)
        expect(html).to match(/<span class="label-text text-base">Name<\/span>/)
      end
    end

    context "with blank i18n translations" do
      around do |example|
        I18n.backend.store_translations(:en, {
          activemodel: {
            attributes: {
              edge_case_model: {
                name: ""
              }
            }
          }
        })
        example.run
        I18n.backend.reload!
      end

      it "falls back when translation is blank" do
        html = builder.text_field(:name)
        expect(html).to match(/<span class="label-text text-base">Name<\/span>/)
      end
    end

    context "with nil i18n translations" do
      around do |example|
        I18n.backend.store_translations(:en, {
          activemodel: {
            attributes: {
              edge_case_model: {
                name: nil
              }
            }
          }
        })
        example.run
        I18n.backend.reload!
      end

      it "falls back when translation is nil" do
        html = builder.text_field(:name)
        expect(html).to match(/<span class="label-text text-base">Name<\/span>/)
      end
    end
  end

  # ============================================================================
  # CUSTOM VALIDATION SCENARIOS
  # ============================================================================

  describe "custom validation scenarios" do
    context "with custom error types" do
      before do
        model.errors.add(:name, "is invalid", type: :invalid)
        model.errors.add(:name, "is required", type: :required)
        model.errors.add(:name, "is too short", type: :too_short)
      end

      it "displays all error types" do
        html = builder.text_field(:name)
        expect(html).to include("is invalid")
        expect(html).to include("is required")
        expect(html).to include("is too short")
      end
    end

    context "with error options" do
      before do
        model.errors.add(:name, "must be at least %{count} characters", count: 5)
      end

      it "interpolates error options" do
        html = builder.text_field(:name)
        expect(html).to include("must be at least 5 characters")
      end
    end
  end
end
