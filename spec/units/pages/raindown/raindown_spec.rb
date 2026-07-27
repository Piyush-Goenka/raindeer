# frozen_string_literal: true

require_relative '../../../../lib/pages/raindown/raindown'

RSpec.describe Rain::Raindown do
  subject(:raindown) { described_class.new }

  let(:markdown) do
    <<~HTML
      <{ :toc }>

      <h2 id="heading-2">Heading 2</h2>
      <p>Paragraph 2</p>
      <h3 id="heading-3">Heading 3</h3>
      <p>Paragraph 3</p>
    HTML
  end

  describe '#render' do
    it 'renders toc' do
      expect(raindown.render(markdown:).squish).to eq(
        <<~HTML.squish
          <div id="toc">
            <h2>Table of contents</h2>
            <ul>
              <li class='h2'><a href='#heading-2'>Heading 2</a></li>
              <li class='h3'><a href='#heading-3'>Heading 3</a></li>
            </ul>
          </div>

          <h2 id="heading-2">Heading 2</h2>
          <p>Paragraph 2</p>
          <h3 id="heading-3">Heading 3</h3>
          <p>Paragraph 3</p>
        HTML
      )
    end
  end
end
