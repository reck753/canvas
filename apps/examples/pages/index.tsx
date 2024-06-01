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
          <li className="line-through">Resize One</li>
          <li className="line-through">Cursor Resize Rect Sides</li>
          <li className="line-through">
            Single Source of Truth (Elements vs SelectedElements)
          </li>
          <li className="line-through">
            Settings per tool (allow resize, ...)
          </li>
          <li className="line-through">
            Custom Tools based on the underlying primitive (e.g. custom rect)
          </li>
          <li className="line-through">Text inside elements</li>
          <li className="line-through">Configurable Line Width</li>
          <li className="line-through">Element onDoubleClick</li>
          <li>More style settings</li>
          <li>Render Agnostic (can be something other than canvas)</li>
          <li className="line-through">Snap</li>
          <li className="line-through">Move to another repo</li>
          <li className="line-through">TS support (tools)</li>
          <li className="line-through">Publish public package</li>
          <div className="h-[1px] w-full bg-black/15" />
          <li>Undo/Redo</li>
          <li>Keyboard support</li>
          <li>Grid</li>
          <li>Zoom</li>
          <li>Rotate</li>
          <li>Ellipse</li>
          <li>Resize Multiple</li>
        </div>
      </div>
    </>
  );
};

export default Index;
