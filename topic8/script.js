const script = (() => {
	window.onload = () => {
		if (typeof web3 === 'undefined') {
			//if there is no web3 variable
			displayMessage("Error! Are you sure that you are using metamask?");
		} else {
			displayMessage("Welcome to our DAPP!");
			init();
		}
	}

	const abi = [
		{
		  "constant": false,
		  "inputs": [
			{
			  "name": "_pokemon",
			  "type": "uint8"
			}
		  ],
		  "name": "announceCatch",
		  "outputs": [
			{
			  "name": "success",
			  "type": "bool"
			}
		  ],
		  "payable": false,
		  "stateMutability": "nonpayable",
		  "type": "function"
		},
		{
		  "constant": true,
		  "inputs": [
			{
			  "name": "_pokemon",
			  "type": "uint8"
			}
		  ],
		  "name": "listPokemonOwners",
		  "outputs": [
			{
			  "name": "",
			  "type": "address[]"
			}
		  ],
		  "payable": false,
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "constant": true,
		  "inputs": [
			{
			  "name": "_owner",
			  "type": "address"
			}
		  ],
		  "name": "listPokemonsOwnedBy",
		  "outputs": [
			{
			  "name": "",
			  "type": "uint8[32]"
			}
		  ],
		  "payable": false,
		  "stateMutability": "view",
		  "type": "function"
		}
	  ];

	const address = "0x8cdaf0cd259887258bc13a92c0a6da92698644c0";

	const pokemons = ["Bulbasaur", "Ivysaur", "Venusaur", "Charmander", "Charmeleon", "Charizard", "Squirtle", "Wartortle", "Blastoise", "Caterpie", "Metapod", "Butterfree", "Weedle", "Kakuna", "Beedrill", "Pidgey", "Pidgeotto", "Pidgeot", "Rattata", "Raticate", "Spearow", "Fearow", "Ekans", "Arbok", "Pikachu", "Raichu", "Sandshrew", "Sandslash", "NidoranF", "Nidorina", "Nidoqueen", "NidoranM"];

	let contractInstance;
	let acc;

	const init = () => {
		const Contract = web3.eth.contract(abi);
		contractInstance = Contract.at(address);
		updateAccount();
	}

	const updateAccount = () => {
		acc = web3.eth.accounts[0];
	}

	const displayMessage = (message) => {
		const el = document.getElementById("message");
		el.innerText = message;
	}

	const getTextInput = () => {
		const el = document.getElementById("input");

		return el.value;
	}

	const claimPokemon = () => {
		updateAccount();
		let pokemonIndex = Number(getTextInput());
		contractInstance.announceCatch(pokemonIndex, { from: acc }, (err, res) => {
			if (err) {
				displayMessage(`Could not claim ${pokemons[pokemonIndex]}`);
				console.error(err);
			} else {
				displayMessage(`Successfully claimed ${pokemons[pokemonIndex]}`);
			}
		});
	}

	const getPokemonsOwnedBy = () => {
		updateAccount();
		let ownerAddress = getTextInput();
		contractInstance.listPokemonsOwnedBy(ownerAddress, (err, res) => {
			if (err) {
				displayMessage(`Could not retrieve ${ownerAddress} pokemons`);
				console.error(err);
			} else {
				const result = [];
				for (let i = 0; i < res.length; i += 1) {
					if (res[i].valueOf() & 1) {
						result.push(pokemons[i]);
					}
				}
				displayMessage(`Pokemons owned by ${ownerAddress}: ${result.join(", ")}`);
			}
		});
	}

	const listPokemonOwnersByPokemonIndex = () => {
		updateAccount();
		let pokemonIndex = Number(getTextInput());
		contractInstance.listPokemonOwners(pokemonIndex, (err, res) => {
			if (err) {
				displayMessage(`Could not retrieve owners for ${pokemons[pokemonIndex]}`);
				console.error(err);
			} else {
				displayMessage(`${pokemons[pokemonIndex]} owners: ${res.join(", ")}`);
			}
		});
	}

	return {
		claimPokemon: claimPokemon,
		getPokemonsOwnedBy: getPokemonsOwnedBy,
		listPokemonOwnersByPokemonIndex: listPokemonOwnersByPokemonIndex
	}
})();