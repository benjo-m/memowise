import { Deck } from "@/models/deck";
import { createContext, useContext, useState } from "react";

type DecksContextType = {
  decks: Deck[];
  setDecks: React.Dispatch<React.SetStateAction<Deck[]>>;
  removeDeck: (id: string) => void;
};

const DecksContext = createContext<DecksContextType | null>(null);

export const useDecks = () => {
  const ctx = useContext(DecksContext);
  if (!ctx) throw new Error("useDecks must be used within a DecksProvider");
  return ctx;
};

export const DecksProvider = ({ children }: { children: React.ReactNode }) => {
  const [decks, setDecks] = useState<Deck[]>([]);

  const removeDeck = (id: string) => {
    setDecks((prev) => prev.filter((deck) => deck.id !== id));
  };

  return (
    <DecksContext.Provider value={{ decks, setDecks, removeDeck }}>
      {children}
    </DecksContext.Provider>
  );
};
