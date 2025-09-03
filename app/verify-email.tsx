import { verifyAccountResend } from "@/api/auth";
import CustomButton from "@/components/custom-button";
import { useSession } from "@/contexts/auth-context";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import { router, useLocalSearchParams } from "expo-router";
import { useState } from "react";
import { Text, View } from "react-native";

export default function VerifyEmail() {
  const { signIn } = useSession();
  const { fromSignUp, email, password } = useLocalSearchParams();
  const [errorMessage, setErrorMessage] = useState("");
  const [errorVisible, setErrorVisible] = useState(false);
  const [emailSentMessageVisible, setEmailSentMessageVisible] = useState(false);

  const signNewUserIn = async (email: string, password: string) => {
    const result = await signIn(email, password);
    if (result?.success) {
      router.replace("/");
    } else {
      setErrorMessage(result?.error!);
      setErrorVisible(true);
    }
  };

  const resendLink = async () => {
    try {
      await verifyAccountResend(email.toString());
      setErrorVisible(false);
      setEmailSentMessageVisible(true);
    } catch (error: any) {
      setErrorMessage(error.error);
      setEmailSentMessageVisible(false);
      setErrorVisible(true);
    }
  };

  return (
    <View style={{ flex: 1, margin: 30 }}>
      <Text
        style={{
          fontSize: 18,
          textAlign: "center",
          fontWeight: "700",
          color: "#2b2b2bff",
          marginBottom: 30,
        }}
      >
        Verification link sent
      </Text>
      <Text
        style={{
          textAlign: "center",
          fontWeight: "500",
          color: "#2b2b2bff",
          marginBottom: 30,
        }}
      >
        We've sent a verification link to{" "}
        <Text style={{ fontWeight: "600", color: "black" }}>{email}</Text>
        {"\n"}
        {"\n"} Please check your inbox and click the link to activate your account.
      </Text>
      {errorVisible && (
        <Text style={{ textAlign: "center", color: "red", marginBottom: 15, fontWeight: "600" }}>
          {errorMessage}
        </Text>
      )}
      {emailSentMessageVisible && (
        <Text style={{ textAlign: "center", color: "green", marginBottom: 15, fontWeight: "600" }}>
          A verification email has been resent to {email}
        </Text>
      )}
      <View style={{ flexDirection: "row", gap: 10 }}>
        <View style={{ flex: 1 }}>
          <CustomButton
            title={"Resend"}
            color={""}
            onPress={async () => resendLink()}
            icon={<FontAwesome name="send" size={18} color="white" />}
          ></CustomButton>
        </View>
        <View style={{ flex: 1 }}>
          <CustomButton
            title={"Done"}
            color={""}
            onPress={
              fromSignUp
                ? async () => await signNewUserIn(email.toString(), password.toString())
                : () => router.back()
            }
            icon={<FontAwesome name="check" size={18} color="white" />}
          ></CustomButton>
        </View>
      </View>
    </View>
  );
}
