import { Flashcard } from "./flashcard";

export type Deck = {
  id: string;
  name: string;
  flashcards: Flashcard[];
};
