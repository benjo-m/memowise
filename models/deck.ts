import { Flashcard } from "./flashcard";

export type Deck = {
  id: number;
  name: string;
  flashcards: Flashcard[];
};
