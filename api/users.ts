import { UserStats } from "@/models/user-stats";
import * as SecureStore from "expo-secure-store";
import { BASE_URL } from "./constants";

export const getUserStats = async (): Promise<UserStats> => {
  const token = await SecureStore.getItemAsync("session");
  const response = await fetch(`${BASE_URL}/users/stats`, {
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  });

  return await response.json();
};
