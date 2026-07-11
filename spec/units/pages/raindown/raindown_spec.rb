# frozen_string_literal: true

require_relative '../../../../lib/pages/raindown/raindown'

RSpec.describe Rain::Raindown do
  subject(:raindown) { described_class.new }

  let(:template) do
    <<~HTML
      <{ :toc }>

      <h2>Heading 2</h2>
      <p>Paragraph 2</p>
      <h3>Heading 3</h3>
      <p>Paragraph 3</p>
    HTML
  end

  describe '#render' do
    it 'renders toc' do
      expect(raindown.render(template:)).to eq(
        <<~HTML.strip
          <div id="toc">
          </div>
          <h2>Heading 2</h2>
          <p>Paragraph 2</p>
          <h3>Heading 3</h3>
          <p>Paragraph 3</p>
        HTML
      )
    end
  end
end
