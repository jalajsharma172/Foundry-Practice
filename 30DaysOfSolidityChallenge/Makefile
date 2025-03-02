-include .env

all: clean remove install update build 




clean  :; forge clean

update:; forge update

build  :; forge clean && forge build --optimize --optimizer-runs 1000000

deploy_goerli:; forge script script/DeployGoerli.s.sol:DeployGoerli --rpc-url $(GOERLI_RPC_URL)  --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_KEY) -vvvvv

deploy-sepolia:; forge script script/Counter.s.sol:CounterScript --rpc-url $(SS) --private-key $(SSPASSWORD) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
