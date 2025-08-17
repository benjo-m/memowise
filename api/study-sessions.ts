import { StudySessionCreateRequest } from "@/models/study-session-create-request";
import * as SecureStore from "expo-secure-store";
import { BASE_URL } from "./constants";

export const createStudySession = async (request: StudySessionCreateRequest) => {
  const token = await SecureStore.getItemAsync("session");

  const response = await fetch(`${BASE_URL}/study_sessions`, {
    method: "POST",
    headers: {
      Accept: "application/json",
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(request),
  });

  if (!response.ok) {
    throw new Error("Failed to create study session.");
  }

  const responseData = await response.json();

  return responseData;
};
