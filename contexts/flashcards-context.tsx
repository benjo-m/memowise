// contexts/flashcards-context.tsx
import { Flashcard } from "@/models/flashcard";
import { FlashcardFreshCreateRequest } from "@/models/flashcard-fresh-create-request";
import { createContext, useContext, useState } from "react";

type FlashcardsContextType = {
  flashcards: Flashcard[] | FlashcardFreshCreateRequest[];
  setFlashcards: React.Dispatch<React.SetStateAction<Flashcard[] | FlashcardFreshCreateRequest[]>>;
};

const FlashcardsContext = createContext<FlashcardsContextType | undefined>(undefined);

export const FlashcardsProvider = ({ children }: { children: React.ReactNode }) => {
  const [flashcards, setFlashcards] = useState<Flashcard[] | FlashcardFreshCreateRequest[]>([]);

  return (
    <FlashcardsContext.Provider value={{ flashcards, setFlashcards }}>
      {children}
    </FlashcardsContext.Provider>
  );
};

export const useFlashcards = () => {
  const context = useContext(FlashcardsContext);
  if (!context) throw new Error("useFlashcards must be used within FlashcardsProvider");
  return context;
};
