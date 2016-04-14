name "salt"
version "2015.8.7"
default_version "2015.8.7"

dependency "python"
dependency "pip"
dependency "pyzmq"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['LD_LIBRARY_PATH'] = '/opt/contegix/salt/embedded/lib'
  command "#{install_dir}/embedded/bin/pip install --build #{project_dir} #{name}==#{version}"
  command "mkdir #{install_dir}/bin"
  command "ln -s #{install_dir}/embedded/bin/salt-minion #{install_dir}/bin/salt-minion"
  command "rsync -a #{Omnibus::Config.project_root}/files/ #{install_dir}/
  #sync "#{Omnibus::Config.project_root}/files", "#{install_dir}"
end
