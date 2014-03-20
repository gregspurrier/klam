require 'spec_helper'

describe 'Klam::Template' do
  include Klam::Template

  describe 'render_string' do
    it 'replaces placeholders with their corresponding arguments' do
      expect(render_string('this $1 a $2.', 'is', 'template'))
        .to eq('this is a template.')
    end

    it 'supports placeholders at the beginning of the template' do
      expect(render_string('$1 world', 'hello')).to eq('hello world')
    end

    it 'supports placeholders at the end of the template' do
      expect(render_string('hello $1', 'world')).to eq('hello world')
    end

    it 'supports placeholders as the complete template' do
      expect(render_string('$1', 'hello')).to eq('hello')
    end

    it 'joins array arguments with a comma before insertion' do
      expect(render_string('[$1]', ['a', 'b', 'c'])).to eq('[a,b,c]')
    end
  end
end
