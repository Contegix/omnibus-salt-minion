name "pycrypto"
version "2.7"

dependency "python"
dependency "pip"

build do
  command "#{install_dir}/embedded/bin/pip install -I --build #{project_dir} #{name}==#{version}"
end
