import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const dateFrom = searchParams.get("dateFrom");
    const dateTo = searchParams.get("dateTo");
    const department = searchParams.get("department");

    const where: any = {};

    if (dateFrom && dateTo) {
      where.date = {
        gte: new Date(dateFrom),
        lte: new Date(dateTo),
      };
    }

    if (department) {
      where.departmentMetrics = {
        contains: department,
      };
    }

    const analytics = await prisma.analytics.findMany({
      where,
      orderBy: {
        date: "desc",
      },
    });

    // Calculate aggregate metrics
    const totalPatients = analytics.reduce(
      (sum, item) => sum + item.totalPatients,
      0
    );
    const totalConsultations = analytics.reduce(
      (sum, item) => sum + item.totalConsultations,
      0
    );
    const avgWaitTime =
      analytics.length > 0
        ? analytics.reduce((sum, item) => sum + item.avgWaitTime, 0) /
          analytics.length
        : 0;

    return NextResponse.json(
      {
        success: true,
        data: {
          analytics,
          aggregates: {
            totalPatients,
            totalConsultations,
            avgWaitTime,
            period: `${dateFrom} to ${dateTo}`,
          },
        },
      },
      { status: 200 }
    );
  } catch (error) {
    console.error("Analytics error:", error);
    return NextResponse.json(
      {
        success: false,
        error:
          error instanceof Error ? error.message : "Internal server error",
      },
      { status: 500 }
    );
  }
}
