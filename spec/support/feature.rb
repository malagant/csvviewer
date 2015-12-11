RSpec.shared_context 'Features', type: :feature do
  instance_eval do
    # rubocop:disable Style/Alias
    alias background before
    alias given let
    alias given! let!
    # rubocop:enable Style/Alias
  end
end
