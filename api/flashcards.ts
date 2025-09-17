import { Flashcard } from "@/models/flashcard";
import { FlashcardCreateRequest } from "@/models/flashcard-create-request";
import { FlashcardStatsUpdateRequest } from "@/models/flashcard-stats-update-request";
import { FlashcardUpdateRequest } from "@/models/flashcard-update-request";
import * as SecureStore from "expo-secure-store";
import { BASE_URL } from "./constants";

export const createFlashcard = async (body: FlashcardCreateRequest): Promise<Flashcard> => {
  const token = await SecureStore.getItemAsync("session");

  const formData = new FormData();
  formData.append("flashcard[front]", body.front);
  formData.append("flashcard[back]", body.back);
  formData.append("flashcard[deck_id]", String(body.deckId));
  if (body.front_image_file) {
    formData.append("flashcard[front_image]", {
      uri: body.front_image_file.uri,
      name: body.front_image_file.name,
      type: body.front_image_file.type,
    } as any);
  }
  if (body.back_image_file) {
    formData.append("flashcard[back_image]", {
      uri: body.back_image_file.uri,
      name: body.back_image_file.name,
      type: body.back_image_file.type,
    } as any);
  }

  const response = await fetch(`${BASE_URL}/flashcards`, {
    method: "POST",
    headers: {
      Accept: "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: formData,
  });

  if (!response.ok) {
    throw new Error("Failed to create flashcard.");
  }

  return await response.json();
};

export const updateFlashcard = async (
  id: number,
  body: FlashcardUpdateRequest
): Promise<Flashcard> => {
  const token = await SecureStore.getItemAsync("session");

  const formData = new FormData();

  formData.append("flashcard[front]", body.front);
  formData.append("flashcard[back]", body.back);

  if (body.front_image_file) {
    formData.append("flashcard[front_image]", {
      uri: body.front_image_file.uri,
      name: body.front_image_file.name,
      type: body.front_image_file.type,
    } as any);
  }

  if (body.back_image_file) {
    formData.append("flashcard[back_image]", {
      uri: body.back_image_file.uri,
      name: body.back_image_file.name,
      type: body.back_image_file.type,
    } as any);
  }

  formData.append("flashcard[remove_front_image]", body.remove_front_image.toString());
  formData.append("flashcard[remove_back_image]", body.remove_back_image.toString());

  const response = await fetch(`${BASE_URL}/flashcards/${id}`, {
    method: "PUT",
    headers: {
      Accept: "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: formData,
  });

  if (!response.ok) {
    throw new Error("Failed to update flashcard.");
  }

  return await response.json();
};

export const batchUpdateFlashcardStats = async (
  flashcards: FlashcardStatsUpdateRequest[]
): Promise<void> => {
  const token = await SecureStore.getItemAsync("session");

  const response = await fetch(`${BASE_URL}/flashcards/batch-update`, {
    method: "PATCH",
    headers: {
      Accept: "application/json",
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ flashcards }),
  });

  if (!response.ok) {
    throw new Error("Failed to update flashcard stats.");
  }
};

export const deleteFlashcard = async (id: number): Promise<void> => {
  const token = await SecureStore.getItemAsync("session");

  const response = await fetch(`${BASE_URL}/flashcards/${id}`, {
    method: "DELETE",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  });

  if (!response.ok) {
    throw new Error("Failed to delete flashcard");
  }
};
