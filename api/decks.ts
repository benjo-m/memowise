import { Deck } from "@/models/deck";
import { BASE_URL } from "./constants";

const url = `${BASE_URL}/decks`;

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

export const getAllDecks = async (): Promise<Deck[]> => {
  const response = await fetch(url);
  return await response.json();
};
