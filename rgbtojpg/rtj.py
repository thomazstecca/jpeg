import numpy as np

def rgb2ycbcr(rgb_image): # https://sistenix.com/rgb2ycbcr.html
    transformation_matrix = np.array([76, 150, 29], [-43, -85, 128], [128, -107, -21]], dtype=np.int16) # equacao
    offset = np.array([0, 128, 128], dtype=np.int16)

    h, w, _ = rgb_image.shape # arrumar tamanho da imagem para multiplicar matrizes
    rgb_flat = rgb_image.reshape(-1, 3).astype(np.int16)

    ycbcr_flat = (rgb_flat @ transformation_matrix.T) >> 8 # aplicar equacao
    ycbcr_flat += offset

    ycbcr_flat = np.clip(ycbcr_flat, 0, 255)

    return ycbcr_flat.reshape(h, w, 3).astype(uint8) # devolve pras dimensoes originais
    
def 2ddct(block):
    N = 8
    SCALE_FACTOR = 256

    cos_table = np.array([[int(SCALE_FACTOR * np.cos((2*x + 1) * u * np.pi / (2*N))) for u in range(N)] for x in range(N)], dtype=np.int16)

    dct_block = np.zeros((N,N),dtype=np.int32)

    for u in range(N):
        for v in range(N):
            sum_value = 0
            for x in range(N):
                for y in range(N):
                    sum_value += block[x, y] * cos_table[x,u] * cos_table[y,v]

            alpha_u = 181 if u == 0 else SCALE_FACTOR
            alpha_v = 181 if v == 0 else SCALE_FACTOR

            dct_block[u,v] = (sum_value * alpha_u * alpha_v) >> 18

    return dct_block

