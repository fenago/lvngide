// Stub for @theia/ai-mcp packages
// Provides empty implementations to satisfy imports

// Common exports
exports.MCPServerManager = class MCPServerManager {};
exports.MCPPreferences = class MCPPreferences {};
exports.McpServerManager = class McpServerManager {};
exports.McpPreferences = class McpPreferences {};

// Mock preferences
exports.MCP_PREFERENCES_SCHEMA = {};

// Browser module
exports.default = {
  rebind() {},
  bind() {}
};

// Backend module  
exports.backendApplicationModule = {
  bind() {}
};
