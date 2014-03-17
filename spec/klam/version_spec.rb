require 'spec_helper'

describe 'Klam::VERSION' do
  it 'is in semver 2.0.0 format' do
    expect(Klam::VERSION).to match(/^\d+\.\d+\.\d+(-[-.a-zA-Z0-9]+)?$/)
  end
end
