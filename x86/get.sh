ROOT_URL=https://raw.githubusercontent.com/chalmers-revere/opendlv.os/master

wget ${ROOT_URL}/x86/{install,install-conf,install-env,install-post}.sh

mkdir setup-root-available
cd setup-root-available
wget ${ROOT_URL}/x86/setup-root-available/setup-env-root-{4g,desktop,pcan,router,wifi}.sh ${ROOT_URL}/x86/setup-root-available/setup-post-root-pacn.sh

cd ..

mkdir setup-user-available
cd setup-user-available
wget ${ROOT_URL}/x86/setup-user-available/setup-env-user-opendlvclone.sh
cd ..
