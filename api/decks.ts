import { Deck } from "@/models/deck";
import * as SecureStore from "expo-secure-store";
import { BASE_URL } from "./constants";

const url = `${BASE_URL}/decks`;
const token = SecureStore.getItem("session");

export const getAllDecks = async (): Promise<Deck[]> => {
  const response = await fetch(url, {
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  });

  return await response.json();
};
