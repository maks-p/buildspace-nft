/** @jsxImportSource @emotion/react */
import { css } from "@emotion/react";
import { ethers } from "ethers";
import { useState, useEffect } from "react";

import Button from "../components/Button";
import MainContainer from "../components/MainContainer";
import Header from "../components/Header";
import GenerativeCocktailABI from "../utils/GenerativeCocktailABI.json";

const CONTRACT_ADDRESS = "0x90816241133de4375E988Ab73c893717997d8178";

const Home = () => {
  const [currentAccount, setCurrentAccount] = useState(null);
  const [numberNFTsMinted, setNumberNFTsMinted] = useState(0);

  const checkWalletConnection = async () => {
    
    const { ethereum } = window;

    if (!ethereum) {
      console.log("Please install Metamask");
      return;
    } else {
      setupEventListener();
      console.log("Ethereum object: ", ethereum);
    }

    const accounts = await ethereum.request({ method: "eth_accounts" });

    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account:", account);
      setCurrentAccount(account);
    } else {
      console.log("No authorized account found");
    }
  };

  const connectWallet = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum) {
        alert("Please install MetaMask!");
        return;
      }

      const accounts = await ethereum.request({
        method: "eth_requestAccounts",
      });

      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]);

    } catch (err) {
      console.log(err);
    }
  };

  const askContractToMintNFT = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(
          CONTRACT_ADDRESS,
          GenerativeCocktailABI.abi,
          signer
        );

        console.log("Pop out wallet");
        let nftTxn = await connectedContract.mintNFT();

        console.log("Mining....please wait");
        await nftTxn.wait();

        console.log(
          `Mined, see transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`
        );
      } else {
        console.log("Ethereum object does not exist");
      }
    } catch (err) {
      console.log(error);
    }
  };

  const setupEventListener = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(
          CONTRACT_ADDRESS,
          GenerativeCocktailABI.abi,
          signer
        );

        connectedContract.on("nftMinted", (from, tokenId) => {
          getNumberNFTsMinted();
          console.log(from, tokenId.toNumber());
        });
        console.log("Setup event listener");
      } else {
        console.log("Ethereum object doesn't exist");
      }
    } catch (err) {
      console.log(err);
    }
  };

  const getNumberNFTsMinted = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const connectedContract = new ethers.Contract(
          CONTRACT_ADDRESS,
          GenerativeCocktailABI.abi,
          provider
        );

        let numMinted = await connectedContract.getMintCount();
        numMinted = numMinted.toNumber();
        setNumberNFTsMinted(numMinted);
      } else {
        console.log("Ethereum object not found");
      }
    } catch (err) {
      console.log(err);
    }
  };

  const renderConnectionButton = () => (
    <Button onClick={connectWallet} text="Connect to Wallet" />
  );

  const renderMintButton = () => (
    <Button onClick={askContractToMintNFT} text="Mint Cocktail" />
  );

  useEffect(() => {
    checkWalletConnection();
    getNumberNFTsMinted();
  }, []);

  useEffect(() => {
    getNumberNFTsMinted();
  }, []);

  return (
    <MainContainer>
      <Header>
        <div>{currentAccount !== null ? "" : renderConnectionButton()}</div>
      </Header>
      <div
        css={css`
          font-size: 3rem;
        `}
      >
        // Generative Cocktails
      </div>
      <div
        css={css`
          font-size: 1.5rem;
        `}
      >
        8,888 randomly generated cocktails. We provide the ingredients, you
        build.
      </div>
      <div
        css={css`
          width: fit-content;
          margin: auto;
          padding: 20px;
        `}
      >
        <div>{currentAccount === null ? "" : renderMintButton()}</div>
      </div>
      <div
        css={css`
          width: fit-content;
          margin: auto;
          padding: 20px;
        `}
      >
        {numberNFTsMinted} / 8,888 minted
      </div>
    </MainContainer>
  );
};

export default Home;
