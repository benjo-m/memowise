import { changePassword } from "@/api/auth";
import CustomButton from "@/components/custom-button";
import { inputStyles } from "@/styles/inputs";
import { Controller, useForm } from "react-hook-form";
import { Alert, Text, TextInput, View } from "react-native";

export default function ChangePasswordScreen() {
  const {
    control,
    handleSubmit,
    setError,
    formState: { errors },
  } = useForm({
    defaultValues: {
      currentPassword: "",
      newPassword: "",
      confirmNewPassword: "",
    },
  });

  const onSubmit = async (data: any) => {
    try {
      await changePassword({
        password: data.currentPassword,
        "new-password": data.newPassword,
        "password-confirm": data.confirmNewPassword,
      });

      Alert.alert("Password changed successfully.", "yay");
    } catch (err: any) {
      const errorField = err["field-error"][0];
      const errorMessage = err["field-error"][1];

      if (errorField == "password") {
        setError("currentPassword", {
          type: "manual",
          message: errorMessage,
        });
      } else if (errorField == "new-password") {
        setError("newPassword", {
          type: "manual",
          message: errorMessage,
        });
      }
    }
  };

  return (
    <View style={{ flex: 1, margin: 30, justifyContent: "space-between" }}>
      <View style={{ gap: 20 }}>
        <View>
          <Text style={{ marginBottom: 8, fontWeight: "600", color: "#2c2c2cff" }}>
            Current password
          </Text>
          <Controller
            control={control}
            rules={{
              required: true,
            }}
            render={({ field: { onChange, onBlur, value } }) => (
              <TextInput
                placeholder="Enter your current password"
                onBlur={onBlur}
                onChangeText={onChange}
                value={value}
                autoCapitalize="none"
                autoComplete="off"
                autoCorrect={false}
                style={inputStyles.base}
              />
            )}
            name="currentPassword"
          />
          {errors.currentPassword && <Text>{errors.currentPassword.message}</Text>}
        </View>

        <View>
          <Text style={{ marginBottom: 8, fontWeight: "600", color: "#2c2c2cff" }}>
            New password
          </Text>

          <Controller
            control={control}
            rules={{
              required: true,
            }}
            render={({ field: { onChange, onBlur, value } }) => (
              <TextInput
                placeholder="Enter your new password"
                onBlur={onBlur}
                onChangeText={onChange}
                value={value}
                autoCapitalize="none"
                autoComplete="off"
                autoCorrect={false}
                style={inputStyles.base}
              />
            )}
            name="newPassword"
          />
          {errors.newPassword && <Text>{errors.newPassword.message}</Text>}
        </View>

        <View>
          <Text style={{ marginBottom: 8, fontWeight: "600", color: "#2c2c2cff" }}>
            Confirm new password
          </Text>

          <Controller
            control={control}
            rules={{
              required: true,
            }}
            render={({ field: { onChange, onBlur, value } }) => (
              <TextInput
                placeholder="Confirm your new password"
                onBlur={onBlur}
                onChangeText={onChange}
                value={value}
                autoCapitalize="none"
                autoComplete="off"
                autoCorrect={false}
                style={inputStyles.base}
              />
            )}
            name="confirmNewPassword"
          />
          {errors.confirmNewPassword && <Text>New password confirmation is required</Text>}
        </View>
      </View>
      <CustomButton
        title={"Change password"}
        color={""}
        onPress={handleSubmit(onSubmit)}
        icon={undefined}
      ></CustomButton>
    </View>
  );
}
