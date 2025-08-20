import { SignInResult } from "@/contexts/auth-context";
import { ChangePasswordRequest } from "@/models/change-password-request";
import * as SecureStore from "expo-secure-store";
import { BASE_URL } from "./constants";

export const signIn = async (email: string, password: string): Promise<SignInResult> => {
  const response = await fetch("http://localhost:3000/login", {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ email, password }),
  });

  if (!response.ok) {
    return { success: false, error: "Invalid credentials" };
  }

  const token = response.headers.get("authorization");

  if (!token) {
    return { success: false, error: "Missing token in response" };
  }

  return { success: true, token: token };
};

export const changePassword = async (request: ChangePasswordRequest) => {
  const token = await SecureStore.getItemAsync("session");

  const response = await fetch(`${BASE_URL}/change-password`, {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify(request),
  });

  const data = await response.json();

  if (!response.ok) {
    throw data;
  }

  console.log("Change password response:", data);
  return data;
};
