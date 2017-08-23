require 'spec_helper'

describe Video do
  it 'saves itself' do
    video = Video.new(title: 'monk', description: 'very nice', rating: 3.1, category: 'drama')
    video.save
    expect(Video.first).to eq(video)
  end
end