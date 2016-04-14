name "pyzmq"
default_version "15.2.0"

dependency "python"
dependency "pip"
dependency "libzmq"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['LD_LIBRARY_PATH'] = '/opt/contegix/salt/embedded/lib'
  command "#{install_dir}/embedded/bin/pip install -I --build #{project_dir} #{name}==#{version} --install-option='--zmq=/opt/contegix/salt/embedded'", env: env
end
