name "salt"
version "2015.8.7"
default_version "2015.8.7"

dependency "python"
dependency "pip"

build do
  command "#{install_dir}/embedded/bin/pip install -I --build #{project_dir} #{name}==#{version}"
  command "mkdir #{install_dir}/bin"
  command "ln -s #{install_dir}/embedded/bin/salt-minion #{install_dir}/bin/salt-minion"
  command "rsync -a #{Omnibus::Config.project_root}/files/ #{install_dir}/"
end
