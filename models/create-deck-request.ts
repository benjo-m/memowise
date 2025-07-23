import { Flashcard } from "./flashcard";

export class CreateDeckRequest {
  name: string;
  flashcards_attributes: Flashcard[];

  constructor(name: string, flashcard_attributes: Flashcard[]) {
    this.name = name;
    this.flashcards_attributes = flashcard_attributes;
  }
}
