# Simple UUID v4 generator - no external dependencies needed
export generateUUID = ->
  # Generate a UUID v4 string
  # Format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
  
  crypto = window.crypto or window.msCrypto
  
  if crypto?.getRandomValues
    # Modern browsers
    buf = new Uint8Array(16)
    crypto.getRandomValues(buf)
    
    # Set version to 4
    buf[6] = (buf[6] & 0x0f) | 0x40
    # Set variant to RFC 4122
    buf[8] = (buf[8] & 0x3f) | 0x80
    
    # Format as UUID string
    hex = Array.from(buf).map((b) -> b.toString(16).padStart(2, '0')).join('')
    "#{hex.slice(0, 8)}-#{hex.slice(8, 12)}-#{hex.slice(12, 16)}-#{hex.slice(16, 20)}-#{hex.slice(20)}"
  else
    # Fallback for older browsers
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
      r = Math.random() * 16 | 0
      v = if c is 'x' then r else (r & 0x3 | 0x8)
      v.toString(16)
    )

export v4 = generateUUID
