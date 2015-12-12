RSpec.shared_context 'Features', type: :feature do
  # rubocop: disable Style/Alias
  instance_eval do
    alias background before
    alias given let
    alias given! let!
  end
  # rubocop: enable Style/Alias
end
