import cv2
import numpy as np
import logging
from PIL import Image
import os

logger = logging.getLogger("gmail_factory.qr")

class QRProcessor:
    """Utility to detect and decode QR codes from byte streams or files."""
    
    @staticmethod
    def decode_from_bytes(image_bytes: bytes) -> str:
        """Decodes QR from raw screenshot bytes using OpenCV."""
        try:
            # Convert bytes to numpy array
            nparr = np.frombuffer(image_bytes, np.uint8)
            img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
            
            if img is None:
                logger.error("Failed to decode image from bytes")
                return ""

            # Initialize OpenCV QR detector
            detector = cv2.QRCodeDetector()
            
            # Detect and decode
            data, vertices, _ = detector.detectAndDecode(img)
            
            if data:
                return data
            
            # If standard detection fails, try preprocessing (grayscale + threshold)
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            _, thresh = cv2.threshold(gray, 128, 255, cv2.THRESH_BINARY)
            
            data, _, _ = detector.detectAndDecode(thresh)
            return data if data else ""
            
        except Exception as e:
            logger.error(f"QR Decoding error: {e}")
            return ""

    @staticmethod
    def decode_from_file(file_path: str) -> str:
        """Decodes QR from a file on disk."""
        if not os.path.exists(file_path):
            return ""
        
        try:
            with open(file_path, "rb") as f:
                return QRProcessor.decode_from_bytes(f.read())
        except Exception as e:
            logger.error(f"QR File Decoding error: {e}")
            return ""
