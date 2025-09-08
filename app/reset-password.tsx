import { resetPassword } from "@/api/auth";
import CustomButton from "@/components/custom-button";
import InputWrapper from "@/components/input-wrapper";
import colors from "@/styles/colors";
import { inputStyles } from "@/styles/inputs";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import Ionicons from "@expo/vector-icons/Ionicons";
import { router } from "expo-router";
import { useState } from "react";
import { Text, TextInput, View } from "react-native";

export default function ResetPassword() {
  const [tempEmail, setTempEmail] = useState("");
  const [email, setEmail] = useState("");
  const [noticeVisible, setNoticeVisible] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [errorMessageVisible, setErrorMessageVisible] = useState(false);
  const [emailSent, setEmailSent] = useState(false);

  const successMessageView = () => {
    return (
      <View
        style={{
          padding: 20,
          backgroundColor: "#d4ffc4ff",
          borderRadius: 10,
          marginBottom: 20,
        }}
      >
        <Text
          style={{
            textAlign: "center",
            color: "green",
            fontWeight: 600,
            fontSize: 16,
          }}
        >
          Email sent!
        </Text>
        <Text style={{ color: "green", marginTop: 10, textAlign: "center" }}>
          An email has been sent to <Text style={{ fontWeight: "600" }}>{email}</Text>.{"\n"}
          {"\n"}
          Click the link we sent you and set up your new password there.
        </Text>
      </View>
    );
  };

  const errorMessageView = () => {
    return (
      <View
        style={{
          padding: 20,
          backgroundColor: "#ffc4c4ff",
          borderRadius: 10,
          marginBottom: 20,
        }}
      >
        <Text style={{ color: "red", textAlign: "center" }}>{errorMessage}</Text>
      </View>
    );
  };

  return (
    <View style={{ flex: 1, margin: 30 }}>
      {noticeVisible && successMessageView()}
      {errorMessageVisible && errorMessageView()}
      <Text
        style={{
          fontSize: 16,
          textAlign: "center",
          fontWeight: "600",
          color: "#2b2b2bff",
          marginBottom: 30,
        }}
      >
        Type in your email and we'll send you a secure link to set a new password
      </Text>
      <View style={{ marginBottom: 10 }}>
        <InputWrapper leadingIcon={<Ionicons name="mail" size={20} color={colors.blue} />}>
          <TextInput
            placeholder="Email"
            placeholderTextColor={"#c6c6c6ff"}
            autoCapitalize="none"
            autoComplete="off"
            autoCorrect={false}
            style={inputStyles.base}
            value={tempEmail}
            onChangeText={setTempEmail}
          />
        </InputWrapper>
      </View>
      {emailSent ? (
        <CustomButton
          title={"Done"}
          color={""}
          onPress={() => router.back()}
          icon={<FontAwesome name="check" size={18} color="white" />}
        ></CustomButton>
      ) : (
        <CustomButton
          title={"Send link"}
          color={""}
          onPress={async () => {
            try {
              await resetPassword(tempEmail);
              setEmail(tempEmail);
              setNoticeVisible(true);
              setErrorMessageVisible(false);
              setEmailSent(true);
            } catch (error: any) {
              if (error["field-error"] && error["field-error"].length >= 2) {
                setErrorMessage(error["field-error"][1]);
              } else if (error.error) {
                setErrorMessage(error.error);
              } else {
                setErrorMessage("An unknown error occurred.");
              }
              setErrorMessageVisible(true);
              setNoticeVisible(false);
            }
          }}
          icon={<FontAwesome name="send" size={18} color="white" />}
        />
      )}
    </View>
  );
}
