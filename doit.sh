cd lzip

#echo "native"
#make clean
#DECODER_ONLY=0 make lzip -j 2 # native build
#mv lzip ../lzma-native

echo "bitcode full (encoder+decoder)"
make clean
DECODER_ONLY=0 ~/Dev/emscripten/emmake make lzip -j 2
mv lzip lzip-full.bc

echo "bitcode decoder only"
make clean
DECODER_ONLY=1 ~/Dev/emscripten/emmake make lzip -j 2
mv lzip lzip-decoder.bc
 
cd ..

echo "javascript full"
~/Dev/emscripten/emcc -O2 lzip/lzip-full.bc -o lzma-full.raw.js
# -s INLINING_LIMIT=0
cat pre.js > lzma-full.js
cat lzma-full.raw.js >> lzma-full.js
cat post.js >> lzma-full.js

echo "javascript decoder"
~/Dev/emscripten/emcc -O2 lzip/lzip-decoder.bc -o lzma-decoder.raw.js
# -s INLINING_LIMIT=0
cat pre.js > lzma-decoder.js
cat lzma-decoder.raw.js >> lzma-decoder.js
cat post.js >> lzma-decoder.js

