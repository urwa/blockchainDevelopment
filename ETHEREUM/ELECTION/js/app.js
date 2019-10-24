App =  {
    web3Provider: null,
    contracts: {},

    init: function() {
        console.log("App.init()");
        return App.initWeb3();
    },

    initWeb3: function() {
        if(typeof web3Provider !== undefined) {
            App.web3Provider = web3.currentProvider;
            console.log("found existing web3 provider");
        } else {
            App.web3Provider = new Web3.providers.HttpProvider("http://127.0.0.1:7545");
            console.log("connecting to local Ganache");
        }

        web3 = new Web3(App.web3Provider);
        console.log("initialized web3 instance");
        return App.initContract();
    },

    initContract: function() {
        $.getJSON("Election.json", function(artifactData) {
            App.contracts.Election = TruffleContract(artifactData);
            App.contracts.Election.setProvider(App.web3Provider);
            console.log("initialized Election contract");
        });
    }
};

$(window).on("load", function() {
    App.init();
});