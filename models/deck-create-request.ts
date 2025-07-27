import { FlashcardFreshCreateRequest } from "./flashcard-fresh-create-request";

export class DeckCreateRequest {
  name: string;
  flashcards_attributes: FlashcardFreshCreateRequest[];

  constructor(name: string, flashcardAttributes: FlashcardFreshCreateRequest[]) {
    this.name = name;
    this.flashcards_attributes = flashcardAttributes;
  }
}
