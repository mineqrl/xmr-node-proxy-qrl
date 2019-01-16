# xmr-node-proxy-qrl

:warning: **That is the modified version of xmr-node-proxy to support Quantum Resistant Ledger (QRL) coin** :warning:

Supports all known cryptonight/heavy/light coins:

* Monero (XMR), MoneroV (XMV), Monero Original (XMO), Monero Classic (XMC), ...
* Wownero (WOW), Masari (MSR), Electroneum (ETN), Graft (GRFT), Intense (ITNS)
* Stellite (XTL)
* Aeon (AEON), Turtlecoin (TRTL), IPBC/BitTube (TUBE)
* Sumokoin (SUMO), Haven (XHV), Loki (LOKI)
* ...

## Setup Instructions

Based on a clean Ubuntu 16.04 LTS minimal install

## Deployment via Installer on Linux

1. Create a user 'nodeproxy' and assign a password (or add an SSH key. If you prefer that, you should already know how to do it)

```bash
useradd -d /home/nodeproxy -m -s /bin/bash nodeproxy
passwd nodeproxy
```

2. Add your user to `/etc/sudoers`, this must be done so the script can sudo up and do it's job.  We suggest passwordless sudo.  Suggested line: `<USER> ALL=(ALL) NOPASSWD:ALL`.  Our sample builds use: `nodeproxy ALL=(ALL) NOPASSWD:ALL`

```bash
echo "nodeproxy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
```

3. Log in as the **NON-ROOT USER** you just created and run the [deploy script](https://raw.githubusercontent.com/mineqrl/xmr-node-proxy-qrl/master/install.sh).  This is very important!  This script will install the proxy to whatever user it's running under!

```bash
curl -L https://raw.githubusercontent.com/mineqrl/xmr-node-proxy-qrl/master/install.sh | bash
```

4. Once it's complete, type `cd xmr-node-proxy-qrl`, then open `config.json` and edit as desired.
5. Once you're happy with the settings, go ahead and start all the proxy daemon, commands follow.

```shell
pm2 start proxy.js --name=proxy --log-date-format="YYYY-MM-DD HH:mm:ss:SSS Z"
pm2 save
```
You can check the status of your proxy by either issuing

```
pm2 logs proxy
```

or using the pm2 monitor

```
pm2 monit
```

## Updating xmr-node-proxy

```bash
cd xmr-node-proxy
./update.sh
```



## Manual Deployment
## Pulling xmr-node-proxy repository

```bash
git pull https://github.com/mineqrl/xmr-node-proxy-qrl.git xmr-node-proxy
```

## Deployment via Docker on Linux OS

1. Install docker-compose using the folowing [instructions](https://github.com/docker/compose/releases)

2. Alternatively use the following commands to install docker-compose v1.23.2

```
sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

3. Pull the xmr-node-proxy repository, using above instructions

4. Once it's complete, type `cd xmr-node-proxy`, then open `config_example.json` and edit as desired.

5. Start proxy

```
sudo docker-compose up -d
```

## Deployment via Docker on Windows 10 with the Fall Creators Update (or newer)

1. Install and run [Docker for Windows](https://docs.docker.com/docker-for-windows/install/) with Linux containers mode.

2. Get xmr-node-proxy sources by downloading and unpacking the latest [xmr-node-proxy-qrl](https://github.com/mineqrl/xmr-node-proxy-qrl/archive/master.zip)
archive to xmr-node-proxy-master directory.

3. Go to xmr-node-proxy-master directory in Windows "Command Prompt" and edit config_example.json file as desired (do not forget to update default QRL wallet).

4. Start xmr-node-proxy using docker-compose:

```
docker-compose up -d
```


## Configuration BKMs

1. Specify at least one main pool with non zero share and "default: true". Sum of all non zero pool shares should be equal to 100 (percent).

2. There should be one pool with "default: true" (the last one will override previous ones with "default: true"). Default pool means pool that is used 
for all initial miner connections via proxy.

3. You can use pools with zero share as backup pools. They will be only used if all non zero share pools became down.

4. You should select pool port with difficulty that is close to hashrate of all of your miners multiplied by 10.

5. Proxy ports should have difficulty close to your individual miner hashrate multiplied by 10.

6. Algorithm names ("algo" option in pool config section) can be taken from [Algorithm names and variants](https://github.com/xmrig/xmrig-proxy/blob/dev/doc/STRATUM_EXT.md#14-algorithm-names-and-variants) table

7. Blob type ("blob_type" option in pool config section) can be as follows

	* cryptonote  - Monero forks like Sumokoin, Electroneum, Graft, Aeon, Intense

	* cryptonote2 - Masari

	* forknote    - Some old Bytecoin forks (do not even know which one)

	* forknote2   - Bytecoin forks like Turtlecoin, IPBC

## Known Issues

VMs with 512Mb or less RAM will need some swap space in order to compile the C extensions for node.
Bignum and the CN libraries can chew through some serious memory during compile.
In regards to this here is guide for T2.Micro servers: [Setup of xmr-node-proxy on free tier AWS t2.micro instance](http://moneroocean.blogspot.com/2017/10/setup-of-xmr-node-proxy-on-free-tier.html).
There is also more generic proxy instalation guide: [Complete guide to install and configure xmr-node-proxy on a Ubuntu 16.04 VPS](https://tjosm.com/7689/install-xmr-node-proxy-vps/)

If not running on an Ubuntu 16.04 system, please make sure your kernel is at least 3.2 or higher, as older versions will not work for this.

Many smaller VMs come with ulimits set very low. We suggest looking into setting the ulimit higher. In particular, `nofile` (Number of files open) needs to be raised for high-usage instances.

In your `packages.json`, do a `npm install`, and it should pass.


## Performance

The proxy gains a massive boost over a basic pool by accepting that the majority of the hashes submitted _will_ not be valid (does not exceed the required difficulty of the pool).  Due to this, the proxy doesn't bother with attempting to validate the hash state nor value until the share difficulty exceeds the pool difficulty.

In testing, we've seen AWS t2.micro instances take upwards of 2k connections, while t2.small taking 6k.  The proxy is extremely light weight, and while there are more features on the way, it's our goal to keep the proxy as light weight as possible.

## Configuration Guidelines

Please check the [wiki](https://github.com/MoneroOcean/xmr-node-proxy/wiki/config_review) for information on configuration

Developer Donations
===================
If you'd like to make a one time donation, the addresses are as follows:
* XMR - ```44qJYxdbuqSKarYnDSXB6KLbsH4yR65vpJe3ELLDii9i4ZgKpgQXZYR4AMJxBJbfbKZGWUxZU42QyZSsP4AyZZMbJBCrWr1```
* AEON - ```WmsEg3RuUKCcEvFBtXcqRnGYfiqGJLP1FGBYiNMgrcdUjZ8iMcUn2tdcz59T89inWr9Vae4APBNf7Bg2DReFP5jr23SQqaDMT```
* ETN - ```etnkQMp3Hmsay2p7uxokuHRKANrMDNASwQjDUgFb5L2sDM3jqUkYQPKBkooQFHVWBzEaZVzfzrXoETX6RbMEvg4R4csxfRHLo1```
* SUMO - ```Sumoo1DGS7c9LEKZNipsiDEqRzaUB3ws7YHfUiiZpx9SQDhdYGEEbZjRET26ewuYEWAZ8uKrz6vpUZkEVY7mDCZyGnQhkLpxKmy```
* GRFT - ```GACadqdXj5eNLnyNxvQ56wcmsmVCFLkHQKgtaQXNEE5zjMDJkWcMVju2aYtxbTnZgBboWYmHovuiH1Ahm4g2N5a7LuMQrpT```
* MSR - ```5hnMXUKArLDRue5tWsNpbmGLsLQibt23MEsV3VGwY6MGStYwfTqHkff4BgvziprTitbcDYYpFXw2rEgXeipsABTtEmcmnCK```
* ITNS - ```iz53aMEaKJ25zB8xku3FQK5VVvmu2v6DENnbGHRmn659jfrGWBH1beqAzEVYaKhTyMZcxLJAdaCW3Kof1DwTiTbp1DSqLae3e```
* WOW - ```Wo3yjV8UkwvbJDCB1Jy7vvXv3aaQu3K8YMG6tbY3Jo2KApfyf5RByZiBXy95bzmoR3AvPgNq6rHzm98LoHTkzjiA2dY7sqQMJ```
* XMV - ```4BDgQohRBqg2wFZ5ezYqCrNGjgECAttARdbh1fNkuAbd3HnNkSgas11QD9VFQMzbnvDD3Mfcky1LAFihkbEYph5oGAMLurw```
* RYO - ```RYoLsi22qnoKYhnv1DwHBXcGe9QK6P9zmekwQnHdUAak7adFBK4i32wFTszivQ9wEPeugbXr2UD7tMd6ogf1dbHh76G5UszE7k1```
* XTL - ```Se3Qr5s83AxjCtYrkkqg6QXJagCVi8dELbHb5Cnemw4rMk3xZzEX3kQfWrbTZPpdAJSP3enA6ri3DcvdkERkGKE518vyPQTyi```
* XHV - ```hvxyEmtbqs5TEk9U2tCxyfGx2dyGD1g8EBspdr3GivhPchkvnMHtpCR2fGLc5oEY42UGHVBMBANPge5QJ7BDXSMu1Ga2KFspQR```
* TUBE - ```bxcpZTr4C41NshmJM9Db7FBE5crarjaDXVUApRbsCxHHBf8Jkqjwjzz1zmWHhm9trWNhrY1m4RpcS7tmdG4ykdHG2kTgDcbKJ```
* LOKI - ```L6XqN6JDedz5Ub8KxpMYRCUoQCuyEA8EegEmeQsdP5FCNuXJavcrxPvLhpqY6emphGTYVrmAUVECsE9drafvY2hXUTJz6rW```
* TRTL - ```TRTLv2x2bac17cngo1r2wt3CaxN8ckoWHe2TX7dc8zW8Fc9dpmxAvhVX4u4zPjpv9WeALm2koBLF36REVvsLmeufZZ1Yx6uWkYG```
* BTC - ```3BzvMuLStA388kYZ9nudfm8L22937dSPS3```
* BCH - ```qrhww48p5s6zw9twhc7cujgwp7vym2k4vutem6f92p```
* ETH - ```0xCF8BABC074C487Ae17F9Ce0394eab492E6A35658```
* LTC - ```MCkjQo99VzoeZQ1piDzLDb4uqNSDRZpx55```

## Known Working Pools

* [mineqrl.net](https://mineqrl.net)

If you'd like to have your pool added, please make a pull request here, or contact Mineqrl.net team at support@mineqrl.net!