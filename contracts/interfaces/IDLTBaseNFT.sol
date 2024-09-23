// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

/// @title IDLTBaseNFT
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTBaseNFT {
    // Events
    /// @notice Emitted when a token is burned.
    event TokenBurned(address indexed burner, uint256 indexed tokenId);
    /// @notice Emitted when a token is safely minted.
    event TokenMinted(address indexed to, uint256 indexed tokenId, string uri);

    // Methods

    function burn(uint256 tokenId) external;

    function tokenURI(uint256 tokenId) external view returns (string memory);

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function getCurrentTokenIdCounter() external view returns (uint256);
}
