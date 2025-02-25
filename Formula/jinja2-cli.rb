class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/0c/df/c16c1757b0cd37c282be4f7bb2addcdf3514272d180ae2ed290a5d2472cd/jinja2-cli-0.8.1.tar.gz"
  sha256 "fb1173811ed5b54205c65131374f342fcb924a5123af53a65fe1ffa7eb40bf19"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2c27fed222d1b4d9fd23854b30559a8d0b5a520d8f08410f2b3be48758f21e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2959f96e55b3d8e3f9030db4ac9d6c8c5ba06e51a1411dd854dcd7765ee46619"
    sha256 cellar: :any_skip_relocation, monterey:       "8a68d03e07b8c6c0c6a70ec8bf40f70efd96aa0b0af1e51a1e3c860f9989a2f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5084fb300d9dbc82aa6a7438f8eafe65595d637b537e18851fbbd4d2b4ab2d11"
    sha256 cellar: :any_skip_relocation, catalina:       "5e58a0cd15e7e8e2fa144ee3ad83a4c9ecb702ba7ded94c463bb9ed59a22a42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e7d85123642611a753faffec7b98fb20ceec023aa550f0f27bc11bce1633749"
  end

  depends_on "python@3.10"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      assert_match version.to_s, shell_output("script -q /dev/null #{bin}/jinja2 --version")
    end
    on_linux do
      assert_match version.to_s, shell_output("script -q /dev/null -e -c \"#{bin}/jinja2 --version\"")
    end
    expected_result = <<~EOS
      The Beatles:
      - Ringo Starr
      - George Harrison
      - Paul McCartney
      - John Lennon
    EOS
    template_file = testpath/"my-template.tmpl"
    template_file.write <<~EOS
      {{ band.name }}:
      {% for member in band.members -%}
      - {{ member.first_name }} {{ member.last_name }}
      {% endfor -%}
    EOS
    template_variables_file = testpath/"my-template-variables.json"
    template_variables_file.write <<~EOS
      {
        "band": {
          "name": "The Beatles",
          "members": [
            {"first_name": "Ringo",  "last_name": "Starr"},
            {"first_name": "George", "last_name": "Harrison"},
            {"first_name": "Paul",   "last_name": "McCartney"},
            {"first_name": "John",   "last_name": "Lennon"}
          ]
        }
      }
    EOS
    output = shell_output("#{bin}/jinja2 #{template_file} #{template_variables_file}")
    assert_equal output, expected_result
  end
end
