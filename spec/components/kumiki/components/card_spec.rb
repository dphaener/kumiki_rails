require "rails_helper"

RSpec.describe Kumiki::Components::Card, type: :model do
  describe "#initialize" do
    context "with defaults" do
      let(:card) { described_class.new }

      it "initializes with false bordered" do
        expect(card.bordered).to eq(false)
      end

      it "initializes with nil shadow" do
        expect(card.shadow).to be_nil
      end

      it "initializes with bg-base-100 color" do
        expect(card.color).to eq("bg-base-100")
      end

      it "initializes with empty html_options" do
        expect(card.html_options).to eq({})
      end
    end

    context "with options" do
      let(:card) do
        described_class.new(
          bordered: true,
          shadow: "lg",
          color: "bg-primary",
          html_options: { id: "my-card" }
        )
      end

      it "sets bordered correctly" do
        expect(card.bordered).to eq(true)
      end

      it "sets shadow correctly" do
        expect(card.shadow).to eq("lg")
      end

      it "sets color correctly" do
        expect(card.color).to eq("bg-primary")
      end

      it "sets html_options correctly" do
        expect(card.html_options).to eq({ id: "my-card" })
      end
    end
  end

  describe "#css_classes" do
    it "generates default classes" do
      card = described_class.new
      expect(card.css_classes).to eq("card bg-base-100")
    end

    it "includes bordered class" do
      card = described_class.new(bordered: true)
      expect(card.css_classes).to eq("card card-border bg-base-100")
    end

    it "includes shadow class" do
      card = described_class.new(shadow: "xl")
      expect(card.css_classes).to eq("card shadow-xl bg-base-100")
    end

    it "includes all options" do
      card = described_class.new(bordered: true, shadow: "lg")
      expect(card.css_classes).to eq("card card-border shadow-lg bg-base-100")
    end

    it "merges custom classes from string" do
      card = described_class.new(html_options: { class: "bg-primary text-white" })
      expect(card.css_classes).to eq("card bg-base-100 bg-primary text-white")
    end

    it "merges custom classes from array" do
      card = described_class.new(html_options: { class: [ "bg-primary", "text-white" ] })
      expect(card.css_classes).to eq("card bg-base-100 bg-primary text-white")
    end

    it "includes custom color" do
      card = described_class.new(color: "bg-primary")
      expect(card.css_classes).to eq("card bg-primary")
    end

    it "handles nil color" do
      card = described_class.new(color: nil)
      expect(card.css_classes).to eq("card")
    end

    it "includes color with all options" do
      card = described_class.new(bordered: true, shadow: "lg", color: "bg-secondary")
      expect(card.css_classes).to eq("card card-border shadow-lg bg-secondary")
    end
  end

  describe "#html_attributes" do
    it "generates default attributes" do
      card = described_class.new
      expected = { class: "card bg-base-100" }
      expect(card.html_attributes).to eq(expected)
    end

    it "includes attributes with options" do
      card = described_class.new(
        bordered: true,
        shadow: "md",
        html_options: { id: "test-card", data: { action: "click" } }
      )

      expected = {
        id: "test-card",
        data: { action: "click" },
        class: "card card-border shadow-md bg-base-100"
      }
      expect(card.html_attributes).to eq(expected)
    end

    it "excludes class from html_options" do
      card = described_class.new(
        html_options: { class: "custom-class", id: "test" }
      )

      expected = {
        id: "test",
        class: "card bg-base-100 custom-class"
      }
      expect(card.html_attributes).to eq(expected)
    end
  end
end
