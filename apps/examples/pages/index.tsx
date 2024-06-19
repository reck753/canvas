import Head from "next/head";
// import { make as Example } from "../src/rescript-example/Examples__RescriptExample.gen";
import { TypescriptExample as Example } from "../src/typescript-example/Examples__TypescriptExample";

const Index = () => {
  return (
    <>
      <Head>
        <title> Home | reck753/canvas </title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <div className="flex p-[100px] gap-10">
        <Example />
        <div className="flex flex-col gap-1">
          <span className="font-bold">TODO</span>
          <li>Rotate</li>
          <li>Undo/Redo</li>
          <li>Keyboard support</li>
          <li>Grid</li>
          <li>Infinite canvas by choice (Move (around) tool)</li>
          <li>Move around by interacting with touch pad / mouse</li>
          <li>Infinite Canvas Grid</li>
          <li>Zoom</li>
          <li>Segment Tool</li>
          <li>Binding elements</li>
          <li>
            Ellipse (is it just the rectangle? With a different selection
            method?)
          </li>
          <li>Resize Multiple</li>
          <li>Delete Tool (move around to delete)</li>
        </div>
      </div>
    </>
  );
};

export default Index;
