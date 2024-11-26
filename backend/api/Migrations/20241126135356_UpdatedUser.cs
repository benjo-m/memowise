using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api.Migrations
{
    /// <inheritdoc />
    public partial class UpdatedUser : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Password",
                table: "Users");

            migrationBuilder.RenameColumn(
                name: "Username",
                table: "Users",
                newName: "FirebaseUid");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "FirebaseUid",
                table: "Users",
                newName: "Username");

            migrationBuilder.AddColumn<string>(
                name: "Password",
                table: "Users",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }
    }
}
